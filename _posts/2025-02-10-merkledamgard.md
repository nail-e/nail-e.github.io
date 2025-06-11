---
title: "Investigation into the relation between processing power and the speed of attacks against cryptographic hashing functions"
layout: post
permalink: /posts/merkledamgard
categories: Research
---
I'm officially an IB survivor: I've graduated IB with a 39 and an A on my Computer Science Extended Essay: a feat I thought was impossible. I've spent a total of 48 hours on my Extended Essay (yes, I counted) and now I hope I can put this Extended Essay out as a whole to the world for free. IB in itself isn't a deplorably bad program - its fruits just reward some of the laborers who put their blood, sweat and tears in the endless IAs, extended writings, exams and content that IB forces you to push out. IB isn't really for everyone and this EE is my way of ensuring that the research I undertook can be shared by me without the fear of a grade.

## Abstract
The advent of cryptographic hash functions (CHFs) was a crucial breakthrough in digital cryptography;
designed to provide irretrievable fingerprints for any form of digital data. The Merkle-Damgård
construction marked a significant milestone which served as a basis for developing
subsequent hash functions families such as MD and SHA. CHFs produce a secure and
unique hash that is nearly impossible to reverse-engineer and could be provided as a ”shared-secret”.
As faster hardware are released by manufacturers, processing time for computations would decrease,
forming a time-memory trade-off where computations needed for CHFs decrease and generated in
a faster amount of time, as faster hardware become commercially available.

Flagship CPUs of chip-manufacturing companies have been designed with high clock speeds,
multiple cores and larger caches which can perform cryptographic operations at faster speeds than
their predecessors. This includes supporting advanced instruction sets which theoretically accelerate
cryptographic calculations by directly supporting operations in time-memory tradeoffs, whilst being
aided by faster clock speeds and multi-core capabilities.

## Links
- **[Download the whole paper here](/assets/downloads/2024-11-11-merkledamgard/elianriezamerkledamgardchfbruteforce.pdf)**
- **[View the Paper on CS EE World](https://cseeworld.wixsite.com/home)**
