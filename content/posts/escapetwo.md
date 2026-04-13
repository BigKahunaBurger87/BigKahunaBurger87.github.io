---
title: "HTB Writeup: EscapeTwo (Easy - Windows)"
date: 2025-04-01
tags: ["HackTheBox", "Windows", "Easy", "ActiveDirectory", "Certipy", "BloodHound", "DACL", "ADCS"]
categories: ["HTB Writeups"]
description: "SMB enumeration → cert abuse with Certipy → DA with NT hash"
showToc: true
---

## ✨ Introduction

This write-up walks through the EscapeTwo machine from Hack The Box. As a Windows-based machine rated "Easy," it offers an engaging dive into Active Directory enumeration, DACL manipulation, and certificate-based privilege escalation.

[9t0wl #1984386](https://app.hackthebox.com/profile/1984386)

---

## 🔎 Reconnaissance

We begin with an Nmap scan to identify open ports and services:

```bash
nmap -sC -sV -Pn -p- 10.10.11.XXX
```

Open ports included typical AD services such as SMB, LDAP, and Kerberos. From there, we began enumerating for usernames and shares.

---

## 🔐 Initial Access

We obtained initial credentials or enumerated shares and usernames via SMB or LDAP. Using these, we authenticated and began exploring AD.

After pivoting through enumeration, we identified a low-privileged user:

```text
rose / [REDACTED]
```

---

## 🪨 Privilege Escalation

Running BloodHound revealed that the user had privileges to modify DACLs. We used `bloodyAD` or `dacledit.py` to assign rights to another account.

With DACLs modified, we leveraged `certipy-ad` to request a certificate and impersonate the privileged account.

---

## 📂 Flags Captured

- **user.txt:** Acquired after gaining initial access with low-privilege credentials.
- **root.txt:** Captured after escalating using certificate abuse via Certipy.

---

## 📚 Lessons Learned

- Windows enumeration with SMB, LDAP, and Kerberos
- DACL manipulation and privilege assignment
- Using BloodHound for privilege mapping
- Abusing AD CS with Certipy for full compromise

Great learning opportunity to reinforce Active Directory privilege escalation techniques!

### ✅ Machine Completed: EscapeTwo
