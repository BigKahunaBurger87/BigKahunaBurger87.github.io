---
title: "HackTheBox - Lame"
date: 2026-02-28T21:12:00-05:00
draft: false
tags: ["htb", "walkthrough", "lame", "linux"]
categories: ["HackTheBox"]
author: "BigKahunaBurger87"
---

------------------------------------------------------
Workflow

Export IP:
```
export IP1=
export MNAME=Lame
```
Make Directory:
```
mkdir -p /home/kali/Desktop/HTB/Machines/$MNAME/nmap
```

```
cd /home/kali/Desktop/HTB/Machines/$MNAME/
```
Nmap Scan:
```bash
sudo nmap -p- -Pn -T5 -O -oA /home/kali/Desktop/HTB/Machines/$MNAME/nmap/nmap.alltcp $IP1
```
Nmap Scan Results:
```

```
Nmap Port sort:
```bash
cat nmap/nmap.alltcp.nmap | grep open | awk -F " " '{ print $1 }' | awk -F "/" '{ print $1 }' > tcp.ports
```

Nmap Version Scan:
```bash
nmap -sC -sV -Pn -p $(tr '\n' , < tcp.ports) -oA nmap.nmap $IP1
```

Nmap Version Scan Results:
```bash

```

Nmap UDP Scan:
```
sudo nmap -Pn -n $IP1 -sU --top-ports=100
```

Nmap UDP Results:
```

```

Nmap Brute Force Creds:
```
nmap -vv --script=ssh-brute.nse -p 22 $IP1
```

```
hydra -l kali -P /usr/share/wordlists/SecLists/Passwords/Common-Credentials/500-worst-passwords.txt ssh://<TARGET IP> -t 64
```

------------------------------------------

Gobuster Subdomain scan:
```
gobuster vhost -u http://<IP> -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -t 10 --exclude-length 301 --append-domain

```
Gobuster  Directory Scan(if 443 add https, -k ):
```bash
gobuster dir -u http://$IP1 -w /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-words.txt -t 64 -x asmx,aspx,asp,txt,pdf,php,cgi-bin
```

Raft wordlist /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt
```
gobuster dir -u http://$IP1 -w /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-words.txt -t 64 -x asmx,aspx,asp,txt,pdf,php,cgi-bin
```
Gobuster Scan Results:
```

```



Gobuster Exclude Length:
```
gobuster dir -w '/home/kali/Desktop/wordlists/dirbuster/directory-list-2.3-medium.txt' -u http://$IP1:PORT -t 42 -b 400,401,403,404 --exclude-length 0

```

--------------------------
DirSearch Scan:
```
dirsearch -u http://$IP1/ -w /usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt -r -R 2 --full-url -t 75
```

DirSearch Scan results:
```

```

______________________________________________________

FFUF Scan:
```
ffuf -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt:FUZZ -u http://TARGET/FUZZ
```

--------------------------------------------------------------------
Subfinder:
```
subfinder -d http://IP -o OUTFILE
```

____________________________________________


Nikto Scan:
```bash
nikto -host=http://$IP
```

Nikto Scan Results:
```bash

```

--------------------------------

Browse with BurpSuite
```bash

```
