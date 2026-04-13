---
title: "HTB Writeup: Cereal (Hard - Windows)"
date: 2025-01-15
tags: ["HackTheBox", "Windows", "Hard", "JWT", "GraphQL", "SSRF", "RCE", "SeImpersonate"]
categories: ["HTB Writeups"]
description: "JWT forgery → GraphQL SSRF → RCE → SeImpersonate → SYSTEM"
showToc: true
---

## 📈 Introduction

![Cereal Logo](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/Cereal.png)

**Cereal** is a hard-rated Windows box from Hack The Box. It combines JWT forgery, GraphQL SSRF, .NET deserialization, and Windows privilege escalation with `SeImpersonatePrivilege`.

One unique challenge was building the **GenericPotato** binary. After multiple failed attempts on my Kali Linux system due to missing .NET Framework 4.5 assemblies, I used my wife's Windows machine with **Visual Studio 2022** and the **.NET v4.8 Developer Pack** to build the executable successfully. 🪢💻

---

## 🔎 Enumeration

![Nmap Scan](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealnmap.png)

Nmap showed ports 80 (HTTP), 443 (HTTPS), and others.

![Login Page](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealloginlandingpage.png)

I visited the login page at `cereal.htb` in the browser. Then I ran directory brute-forcing with `dirsearch` and discovered the presence of a `.git` folder in the output.

![DirSearch Results](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealdirsearch.png)

---

## 📜 Discovering the Frontend

![Curl Landing Page Obfuscated](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealcurlobfus.png)

I used `curl` to fetch and analyze the obfuscated login page source. This revealed bundled JavaScript files such as `jquery.js`, `bootstrap.js`, and `modernizr.js`.

![Curl Local JS Files](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cereal_curl_local_files.png)

---

## 🔍 Git Enumeration

![Git Dumper](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealgitdumper.png)

![Git Log Output](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealgitlog.png)

Using `git-dumper`, I dumped the hidden Git repository and inspected the commit history. I found a leaked private key used to sign JWTs.

---

## 🔐 JWT Forging & Access

![Beautify JS](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealbeautify.png)

I beautified the JS bundle to understand JWT validation logic and token structure. The application was using RS256 which allowed key confusion attacks if we had the private key.

![JWT Forge Script](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cereal_forged_jwt_py_script.png)

![Missing Expiration Error](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cereal_jwt_error_missing_exp_claim.png)

Forged tokens using the leaked RSA key. My initial attempt failed due to missing required claims like `exp`. Once added, the token worked and allowed me access to internal functionality.

---

## 🗕️ Payload Delivery

![Python File Host](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealpythonserver.png)

I hosted payloads like `shell.aspx` and `nc.exe` on my attack machine with `python3 -m http.server`. These would be used later as the target server made outbound HTTP requests through SSRF.

---

## ⚡ First Shell Gained

![Remote Connect before Shell](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cereal_remote_connection.png)

After sending a forged JWT and pointing the SSRF `sourceURL` to my malicious `shell.aspx`, I received a reverse shell from the system as user `sonny`. From here, I explored the machine and prepared for privilege escalation.

Running the command `whoami /priv` under the `sonny` shell revealed:

```text
Privilege Name                Description                               State
===========================   =========================================  ========
SeImpersonatePrivilege        Impersonate a client after authentication  Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set             Disabled
SeChangeNotifyPrivilege       Bypass traverse checking                   Enabled
```

These privileges confirmed the feasibility of using **GenericPotato** for a SYSTEM-level token impersonation attack.

The user flag was located at: `C:\Users\sonny\Desktop\user.txt`

---

## 🧵 Setup for SYSTEM Access

![Reverse Shell Connection](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealsshconnection.png)

I used `scp` from my Kali machine to upload `nc64.exe` and `GenericPotato.exe` into `C:\ProgramData\` on the target using Sonny's shell:

```bash
scp nc64.exe kali@<target>:/home/kali/
scp GenericPotato.exe kali@<target>:/home/kali/
```

Then I started `GenericPotato.exe` with the reverse shell parameters. This was the command that initiated SYSTEM impersonation:

![GenericPotato Running Before SYSTEM Shell](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cereal_reverse_shellcmd.png)

---

## 🥪 GraphQL SSRF to Trigger RCE

![Curl Command for RCE](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cereal_curl_for_rce.png)

To execute GenericPotato and trigger the `SeImpersonatePrivilege` exploit, I used SSRF via the `updatePlant` mutation in the internal GraphQL API. I had three terminals open: one listener on port `4444`, one terminal running `GenericPotato` on Sonny's shell, and one to send the GraphQL mutation.

```bash
curl -k -X POST -H "Content-Type: application/json" \
--data-binary '{"query":"mutation{updatePlant(plantId:2, version:2.2, sourceURL:\"http://localhost:8889\")}"}' \
http://localhost:8081/api/graphql
```

This triggered the HTTP listener, which caught a SYSTEM-level authentication request. GenericPotato duplicated the token and attempted to spawn a reverse shell as SYSTEM.

---

## 🛠️ SYSTEM Access

I confirmed SYSTEM-level access and began privilege escalation enumeration. The final shell connected back and I navigated to retrieve `C:\Users\Administrator\Desktop\root.txt`.

---

## 🌼 Rooted!

![Pwned Screenshot](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/cerealpwned.png)

All flags collected! This machine required real persistence, deep enumeration, and multi-stage web-to-system chaining. It's one of the toughest boxes I've tackled—and the most rewarding.

---

## 📚 Key Takeaways

- JWT key forgery with RS256 + private key leakage
- GraphQL mutation abuse for SSRF and internal payload delivery
- SeImpersonate-based privesc using GenericPotato + port forwarding
- Creative use of multiple systems (including Visual Studio on Windows) to overcome build barriers

### ✅ Machine Completed: Cereal

[BigKahunaBurger87 #192375](https://app.hackthebox.com/users/192375)
