---
title: "HTB Writeup: BoardLight (Easy - Linux)"
date: 2025-02-01
tags: ["HackTheBox", "Linux", "Easy", "SQLi", "Dolibarr", "CVE-2023-30253", "LinPEAS", "Enlightenment"]
categories: ["HTB Writeups"]
description: "SQLi + Dolibarr CVE + Privesc with Enlightenment exploit"
showToc: true
---

## 📈 Introduction

![BoardLight Logo](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/BoardLight.png)

In the world of cybersecurity, practical skills are as crucial as theoretical knowledge. "BoardLight," a captivating machine on Hack The Box, offered an exceptional opportunity to hone my penetration testing skills through a series of intriguing challenges ranging from initial access via web vulnerabilities to complex privilege escalations.

{{< toolbadges "Nmap" "ffuf" "whatweb" "LinPEAS" "Netcat" "CVE-2023-30253 Exploit" "Enlightenment Exploit" >}}

---

## 🎯 Objectives

Embarking on the "BoardLight" challenge, my primary goals were to:

- **Enhance Problem-Solving Skills:** Apply and improve my analytical abilities in real-world security scenarios, focusing on identifying and exploiting vulnerabilities in a controlled environment.
- **Master Web Exploitation Techniques:** Delve deeper into common web vulnerabilities, understand their workings, and learn how to exploit them effectively.
- **Explore Privilege Escalation:** Gain a practical understanding of various privilege escalation techniques by identifying and exploiting misconfigurations and vulnerabilities in system services and applications.
- **Apply Security Tools and Scripts:** Utilize popular security tools and custom scripts effectively to automate the reconnaissance and exploitation processes.
- **Document the Learning Process:** Record each step, including both successes and setbacks, to create a comprehensive guide.

---

## 🔎 Reconnaissance

The reconnaissance phase was crucial in laying the groundwork for a successful penetration into the "BoardLight" system.

### Network Scanning

I employed nmap to uncover open ports and detect running services on the target machine. This initial scan helped identify SSH (port 22) and HTTP (port 80) as potential entry points.

![Nmap Scan](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightnmap.png)

---

## 🌐 Enumeration

After exploring the site without much result, I decided to employ the ffuf tool to dive deeper into its structure.

![BoardLight Homepage](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlighthomepage.png)

![ffuf scan](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightffufscan.png)

Right from the start we get "crm", so let's check it out.

![BoardLight Login](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightlogin.png)

Let's try something basic like `admin:admin` and see if that works.

![BoardLight Dashboard](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightlogindash.png)

After exploring the website and noticing control options under the Websites tab, I returned to the terminal and ran `whatweb` for deeper information gathering.

![whatweb output](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightwebget.png)

While inspecting the server's output, I noticed a reference to the 'Dolibarr Development Team.' A quick Google search revealed that Dolibarr 17.0.0 is susceptible to a PHP code injection vulnerability (CVE-2023-30253).

![BoardLight PHP test](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightphptest.png)

Nothing happened initially, so I tried changing lowercase "php" to uppercase "PHP":

![BoardLight PHP success](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightphpsuccess.png)

I found an exploit by nikn0laty for Dolibarr <= 17.0.0 (CVE-2023-30253) and cloned it:

![BoardLight Git Clone](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightgitclone.png)

Setting up listener and running the exploit:

![BoardLight Listener](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightncconnect.png)

After several privilege escalation attempts yielded nothing, I set up an HTTP server to download LinPEAS:

![BoardLight HTTP Server](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightserver.png)

![BoardLight Linpeas](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightlinpeas.png)

LinPEAS revealed an interesting file:

```text
[Interesting Files] -rw-r--r-- 1 www-data www-data 2.3K Sep 6 09:22
/var/www/html/crm.board.htb/htdocs/conf/conf.php
```

Contents of the conf.php file:

![BoardLight Config File](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightconfig.png)

We see a username and password:

```text
user=dolibarrowner
pass=[REDACTED]
```

LinPEAS also revealed a user account:

```text
[User Permissions] User: larissa  Permissions: /bin/bash  Groups: larissa
```

Trying the found password against the `larissa` account:

![BoardLight Larissa Login](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightlarissalogin.png)

**BOOM!** Connection established — let's find the flag:

![BoardLight User Flag](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightuserflag.png)

---

## 🚀 Privilege Escalation

Checking sudo privileges:

```bash
larissa@boardlight:~$ sudo -l
[sudo] password for larissa:
Sorry, user larissa may not run sudo on localhost.
```

Back to LinPEAS for a deeper look:

```text
[Interesting Files] -rwsr-xr-x 1 root root 42224 Jul 21 2024 /usr/bin/enlightenment_sys
```

Researching Enlightenment revealed an exploit by MaherAzzouzi. I cloned the exploit and set up an HTTP server to transfer it to the target:

![BoardLight Exploit](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightexploit.png)

Running it:

![BoardLight Pwned](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/boardlightpwned.png)

Our efforts paid off, and we successfully captured the final flag! This machine offered a wealth of learning opportunities, reinforcing the invaluable lesson that persistence and continuous learning are key in the field of cybersecurity. Keep exploring, and happy hunting!

