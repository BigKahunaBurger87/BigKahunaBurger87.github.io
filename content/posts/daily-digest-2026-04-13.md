---
title: "Daily Cyber Digest: April 13, 2026"
date: 2026-04-13
tags: ["News", "Daily Digest", "Malware", "DataBreach", "Vulnerability", "ZeroDay", "Phishing"]
categories: ["Daily Digest"]
description: "Today's top cybersecurity stories: Adobe zero-day, Booking.com breach, CPUID supply chain attack, W3LL phishing takedown, and more."
showToc: true
---

Alright, another Monday, another dumpster fire in the security world. Grabbed coffee, pulled up my feeds, and honestly today was a lot. Let me break down what caught my attention.

---

## 🔴 Adobe — Again — Zero-Day in the Wild (CVE-2026-34621)

So this one's been silently getting people since **December**. Adobe just dropped an emergency patch today for Acrobat and Reader, and I mean emergency — this wasn't a scheduled Tuesday release. CVE-2026-34621 has been actively exploited in targeted attacks for months before anyone said a word publicly.

This is exactly the kind of thing that frustrates me. Four months of active exploitation before an out-of-band patch. If you have Acrobat installed, stop reading this and go patch it right now. I'll wait.

📎 [BleepingComputer](https://www.bleepingcomputer.com/news/security/adobe-rolls-out-emergency-fix-for-acrobat-reader-zero-day-flaw/)

---

## 🏦 The CPUID Thing Is Genuinely Scary

Okay so this one hit close to home because I've downloaded CPU-Z more times than I can count. Turns out **cpuid.com was compromised for about 19 hours** — April 9th to 10th — and during that window, the download links for CPU-Z and HWMonitor were quietly swapped out to point to malware-dropping fakes deploying something called **STX RAT**.

What makes this worse is how clean it looked. CPUID said a "secondary API" got popped and it caused the main site to serve malicious links. The signed original files were fine — but if you just clicked download without thinking? You got hit. And let's be real, nobody checks hashes on a tool they've downloaded a dozen times before.

The malicious domains if you want to check your DNS/proxy logs:
- `cahayailmukreatif.web[.]id`
- `pub-45c2577dbd174292a02137c18e7b1b5a.r2[.]dev`
- `transitopalermo[.]com`
- `vatrobran[.]hr`

If you downloaded anything from cpuid.com on April 9th or 10th — assume compromise, rebuild.

📎 [The Hacker News](https://thehackernews.com/2026/04/cpuid-breach-distributes-stx-rat-via.html)

---

## 🗄️ Three Breaches Walk Into a Bar...

### Booking.com
Another one. Booking.com confirmed unauthorized access to their systems — reservation data, personal info, the usual. They're forcing PIN resets which tells me the exposure was real and meaningful. If you've got a trip booked or saved payment info on there, I'd go change passwords and keep an eye out for targeted phishing. Attackers love using stolen reservation data to craft convincing follow-up lures.

📎 [BleepingComputer](https://www.bleepingcomputer.com/news/security/new-bookingcom-data-breach-forces-reservation-pin-resets/)

### Basic-Fit
Dutch gym chain Basic-Fit got hit and roughly a million members had their data exposed. This one's not going to make massive headlines but it matters — gym memberships have home addresses, payment data, sometimes ID. Not great. If you're a member, check your email for their notification.

📎 [BleepingComputer](https://www.bleepingcomputer.com/news/security/european-gym-giant-basic-fit-data-breach-affects-1-million-members/)

### Rockstar Games
ShinyHunters leaked analytics data from Rockstar, but here's the thing — Rockstar itself didn't get breached directly. Their vendor **Anodot** did. This is the third-party supply chain problem playing out in real time, again. Companies spend millions hardening their own perimeter and then a smaller vendor with access to their data gets popped. Rinse and repeat.

📎 [BleepingComputer](https://www.bleepingcomputer.com/news/security/stolen-rockstar-games-analytics-data-leaked-by-extortion-gang/)

---

## 🕸️ W3LL Phishing Service Taken Down — Developer Arrested

Genuinely good news today. The FBI, working with Indonesian authorities, took down **W3LL** — a phishing-as-a-service platform that was basically handing script kiddies a ready-made MFA-bypass phishing kit on a subscription. The alleged developer got arrested in Indonesia.

What's notable here is this is reportedly the **first joint US-Indonesia enforcement action** against a phishing kit dev. International cybercrime cooperation is slow and painful but this is a W. Hopefully it sticks.

📎 [BleepingComputer](https://www.bleepingcomputer.com/news/security/fbi-takedown-of-w3ll-phishing-service-leads-to-developer-arrest/)

---

## 🔐 wolfSSL — Critical Cert Forgery Bug

This one is going to quietly affect a ton of things people aren't even thinking about. wolfSSL is everywhere — embedded devices, IoT gear, routers — and there's a critical vulnerability where attackers can **forge certificates** by abusing how the library verifies hash algorithms in ECDSA signatures. 

The headache with wolfSSL vulns is you're not just patching an app on your laptop. Half the time the vulnerable version is baked into firmware that the vendor won't update for 18 months, if ever. Still — worth auditing what you run that might pull it in as a dependency.

📎 [BleepingComputer](https://www.bleepingcomputer.com/news/security/critical-flaw-in-wolfssl-library-enables-forged-certificate-use/)

---

## 🦠 JanelaRAT Still Grinding Through Latin America

Kaspersky dropped a report on **JanelaRAT** today — basically a souped-up banking trojan that's been absolutely hammering Brazil and Mexico. Over **14,700 attacks in Brazil** and nearly **12,000 in Mexico** in 2025. The thing uses a custom title-bar detection trick to figure out when a victim has a targeted banking site open, then starts keylogging and screenshotting.

The operators are actively updating it too, which tells you this is a well-funded, ongoing operation and not some old malware limping along. If you're working with clients in LatAm, this is worth flagging.

📎 [The Hacker News](https://thehackernews.com/2026/04/janelarat-malware-targets-latin.html)

---

## 📍 Law Enforcement Was Tracking Half a Billion Devices Through Ads

Okay this one genuinely bothered me. Citizen Lab published a report showing that law enforcement agencies — including **ICE, DHS, and multiple US police departments**, plus Hungarian intelligence and El Salvador police — were using a tool called **Webloc** to track the physical location of devices. No warrants. Just buying access to ad bid-stream data and running it through a surveillance platform built by Israeli company Cobwebs Technologies, now sold by **Penlink**.

500 million devices. Through ads. The infrastructure that serves you a banner ad about running shoes is the same infrastructure being used to physically locate people. I think about the implications of that a lot.

📎 [The Hacker News](https://thehackernews.com/2026/04/citizen-lab-law-enforcement-used-webloc.html)

---

## 🍎 OpenAI Had a Supply Chain Scare Too

OpenAI rotated their macOS code-signing certificates after a GitHub Actions workflow accidentally executed a **malicious Axios npm package** — a supply chain attack that hit their build pipeline. No user data was directly compromised, but the scary part is that a poisoned package in your CI/CD could potentially sign malicious binaries with your legit cert before anyone notices.

It's a good reminder: your build pipeline is part of your attack surface. Lock it down like you would production.

📎 [BleepingComputer](https://www.bleepingcomputer.com/news/security/openai-rotates-macos-certs-after-axios-attack-hit-code-signing-workflow/)

---

## 🧠 Quick Hits Table

| Story | Severity | What To Do |
|---|---|---|
| Adobe Acrobat zero-day | 🔴 Critical | Patch now, not later |
| CPUID supply chain | 🔴 Critical | Check Apr 9–10 downloads |
| Booking.com breach | 🟠 High | Change credentials |
| W3LL takedown | 🟢 Win | Nothing — just enjoy it |
| wolfSSL cert forgery | 🔴 Critical | Audit your dependencies |
| JanelaRAT banking malware | 🟠 High | Flag for LatAm-facing clients |
| Webloc ad surveillance | 🟡 Awareness | Know it exists |
| OpenAI cert rotation | 🟡 Medium | Review your own CI/CD security |

---

Stay paranoid out there.

*Sources: [The Hacker News](https://thehackernews.com) · [BleepingComputer](https://www.bleepingcomputer.com)*

[BigKahunaBurger87 #192375](https://app.hackthebox.com/users/192375)
