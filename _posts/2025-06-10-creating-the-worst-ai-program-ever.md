---
title: "Creating the worst AI program ever"
layout: post
permalink: /posts/creating-the-worst-ai-program-ever
categories: 
    - Programming
    - Linux
---

Over an afternoon, I created [futa](https://github.com/nail-e/futa), or the **F**unctionally **U**seless **T**erminal **A**ssistant. Written in 2 hours, backed by Ollama and written with Python, it's runs in any UNIX environment as an AI assistant, taking control of your terminal when running `futa "prompt"` on the terminal. It's the perfect HR pitch; something to back your vibe coders who don't know what to do in the terminal, it's also resource-light and runs on an UNIX system. But of course, it's a tongue-in-cheek semi-harmful joke program (see name) which shouldn't EVER be run on anything serious.

{% highlight bash %}

[nail_@nailCPU ~]$ futa "Can you create a directory in this directory called futatest"
[nail_@nailCPU ~]$ futa "Can you change directory into futatest from this directory?"
[nail_@nailCPU futatest]$ futa "Can you create a text file called hello.txt and write a standard Hello World message in it then echo the message?"
Hello World!
[nail_@nailCPU futatest]$ cat hello.txt 
Hello World!

{% endhighlight %}

## 

## Links
- **[Github Page](https://github.com/nail-e/futa)**
- **[Hacker News Post](https://news.ycombinator.com/item?id=44217707)**
