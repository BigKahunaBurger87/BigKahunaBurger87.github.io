---
title: "Daily Cyber Digest: April 13, 2026"
date: 2026-04-13
tags: ["News", "Daily Digest", "Malware", "DataBreach", "Vulnerability", "ZeroDay", "Phishing"]
categories: ["Daily Digest"]
description: "Today's top cybersecurity stories: Adobe zero-day, Booking.com breach, CPUID supply chain attack, W3LL phishing takedown, and more."
showToc: true
---

> 📡 **Daily intel roundup** — summarized from The Hacker News & BleepingComputer. Stay sharp.

---

## 🔴 Critical: Adobe Acrobat/Reader Zero-Day (CVE-2026-34621)

Adobe pushed an **emergency out-of-band patch** for Acrobat and Acrobat Reader today fixing a zero-day vulnerability that has been actively exploited in the wild since at least **December 2025**. The flaw, tracked as **CVE-2026-34621**, was being used in targeted attacks before a fix was available. If you have Acrobat or Reader installed — **patch it now**, this is not a wait-for-patch-Tuesday situation.

📎 [Source – BleepingComputer](https://www.bleepingcomputer.com/news/security/adobe-rolls-out-emergency-fix-for-acrobat-reader-zero-day-flaw/)

---

## 🏦 CPUID Supply Chain Attack — Trojanized CPU-Z & HWMonitor

For roughly **19 hours** (April 9–10), the popular hardware monitoring site **cpuid.com** was compromised. Download links for CPU-Z and HWMonitor were silently replaced with links to malicious executables that deployed **STX RAT** — a remote access trojan. CPUID confirmed the breach on X, attributing it to a compromised "secondary feature/side API." The original signed binaries were **not** affected, but anyone who downloaded during that window should treat their machine as compromised.

**Malicious domains used:**
- `cahayailmukreatif.web[.]id`
- `pub-45c2577dbd174292a02137c18e7b1b5a.r2[.]dev`
- `transitopalermo[.]com`
- `vatrobran[.]hr`

📎 [Source – The Hacker News](https://thehackernews.com/2026/04/cpuid-breach-distributes-stx-rat-via.html)

---

## 🗄️ Data Breaches Round-Up

### Booking.com
Booking.com confirmed unauthorized access to its systems, exposing **reservation and user data**. The company is forcing **reservation PIN resets** for affected users. If you use Booking.com, change your credentials and watch for phishing follow-up attacks targeting exposed reservation data.

📎 [Source – BleepingComputer](https://www.bleepingcomputer.com/news/security/new-bookingcom-data-breach-forces-reservation-pin-resets/)

### Basic-Fit (European Gym Chain)
Dutch gym operator **Basic-Fit** disclosed a breach affecting **~1 million members**. Attacker access included customer personal information. If you're a member, expect a notification and be cautious of credential-stuffing attempts on other accounts.

📎 [Source – BleepingComputer](https://www.bleepingcomputer.com/news/security/european-gym-giant-basic-fit-data-breach-affects-1-million-members/)

### Rockstar Games
**ShinyHunters** leaked analytics data stolen from **Anodot**, a third-party data platform used by Rockstar. This is a classic third-party/supply-chain breach — the target wasn't Rockstar's core systems, but their vendor's. Expect more of these.

📎 [Source – BleepingComputer](https://www.bleepingcomputer.com/news/security/stolen-rockstar-games-analytics-data-leaked-by-extortion-gang/)

---

## 🕸️ FBI Takes Down W3LL Phishing Platform — Developer Arrested

The **FBI Atlanta Field Office**, working with Indonesian authorities, dismantled the **W3LL** phishing-as-a-service platform and arrested its alleged developer. W3LL was a sophisticated tool that allowed low-skill attackers to run MFA-bypassing phishing campaigns at scale. This is reportedly the **first joint US–Indonesia enforcement action** targeting a phishing kit developer — a positive step for international cybercrime cooperation.

📎 [Source – BleepingComputer](https://www.bleepingcomputer.com/news/security/fbi-takedown-of-w3ll-phishing-service-leads-to-developer-arrest/)

---

## 🔐 Critical wolfSSL Vulnerability — Forged Certificates

A **critical bug** in the widely-used **wolfSSL** library allows attackers to forge certificates by exploiting improper verification of the hash algorithm during **ECDSA signature** checking. wolfSSL is embedded in everything from IoT devices to embedded systems. Check your dependencies — if anything in your stack uses wolfSSL, prioritize patching.

📎 [Source – BleepingComputer](https://www.bleepingcomputer.com/news/security/critical-flaw-in-wolfssl-library-enables-forged-certificate-use/)

---

## 🦠 JanelaRAT Banking Malware — 14,739 Attacks in Brazil

**JanelaRAT**, a modified version of BX RAT, continues hammering **Latin American financial institutions**. Kaspersky reports **14,739 attacks in Brazil** and **11,695 in Mexico** in 2025 alone. The malware uses a custom title-bar detection mechanism to target specific banking portals, logging keystrokes, taking screenshots, and stealing crypto wallet data. The threat actors are actively updating the infection chain.

📎 [Source – The Hacker News](https://thehackernews.com/2026/04/janelarat-malware-targets-latin.html)

---

## 📍 Surveillance: Law Enforcement Tracked 500M Devices via Ad Data

**Citizen Lab** published a report revealing that **Hungarian intelligence**, **El Salvador police**, and multiple **US law enforcement agencies** (including ICE, DHS, and various police departments) used a tool called **Webloc** — built by Israeli company Cobwebs Technologies — to track the location of **500 million devices** using advertising bid-stream data. No warrant required. The tool is now sold by **Penlink** after a 2023 merger.

This is a big one for privacy advocates. Ad-tech surveillance infrastructure continues to be repurposed as mass tracking tooling with minimal oversight.

📎 [Source – The Hacker News](https://thehackernews.com/2026/04/citizen-lab-law-enforcement-used-webloc.html)

---

## 🍎 OpenAI Rotates macOS Code-Signing Certs

OpenAI rotated potentially exposed **macOS code-signing certificates** after a GitHub Actions workflow inadvertently executed a **malicious Axios npm package** during a supply chain attack. While no user data was directly impacted, this is a reminder that CI/CD pipelines are high-value targets — a compromised package in your build workflow can sign malicious binaries with your legitimate certificates.

📎 [Source – BleepingComputer](https://www.bleepingcomputer.com/news/security/openai-rotates-macos-certs-after-axios-attack-hit-code-signing-workflow/)

---

## 🧠 TL;DR

| Story | Severity | Action |
|---|---|---|
| Adobe Acrobat zero-day | 🔴 Critical | Patch immediately |
| CPUID supply chain attack | 🔴 Critical | Check downloads from Apr 9–10 |
| Booking.com breach | 🟠 High | Reset credentials |
| W3LL phishing takedown | 🟢 Win | No action needed |
| wolfSSL cert forgery | 🔴 Critical | Check if you use wolfSSL |
| JanelaRAT banking trojan | 🟠 High | Relevant if in LatAm region |
| Webloc mass surveillance | 🟡 Medium | Awareness |
| OpenAI cert rotation | 🟡 Medium | Watch for supply chain attacks |

---

*Sources: [The Hacker News](https://thehackernews.com) · [BleepingComputer](https://www.bleepingcomputer.com)*

[BigKahunaBurger87 #192375](https://app.hackthebox.com/users/192375)
