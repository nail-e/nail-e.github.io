---
title: "Putting AI in the Linux Terminal, and creating the worst AI program ever"
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

## Why would you make this?
This stemmed as a joke from my friends after we first saw the carnage and absolute banality of [Calvin Liang's is-even-ai](https://github.com/Calvin-LL/is-even-ai) npm package. It's uselessness is unbound as an "is even" program can be made in approximately less than one line as seen below.

```c
#include "stdio.h"
#include "stdbool.h""

bool isEven(int num);

bool isEven(int num) {
    return (num % 2 == 0)
}
```

And, if you're a savant, you can do it in one line! 

```c
#define isEven(x) !(x&1)
```

It's amazing of what technology can do in the 21st century right?

And that why I made a program that has no potential downside and is completely safe-to-use! `futa` takes hold of your terminal after you write a prompt and executes it with sudo permissions: imagine the endless possibilities you can do with `futa` on your computer! Imagine writing `touch newFile.txt` when you can ask `futa` 

```sh
futa "Can you create a file in the current directory called newFile.txt?"
```

Brilliant.

## Does this actually have any use case? 
[No.](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview) Please learn your way around the UNIX terminal! 

## How does it work?
It's pretty straightforward: ollama is installed as a dependency with `futa`, meaning that all the commands are generated on-system. `futa` asks ollama to generate the input passed by the user and processes it while omitting the result of the program from being executed.

```python
try:
    subprocess.run(["sudo", "ollama", "pull", "qwen3:0.6b"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    system_prompt = "Answering ONLY in UNIX commands. Do not explain, no output, no markdown, no formatting, no commentary. One command per line. If the question is unrelated to UNIX commands or answering in a UNIX command is impossible, the respond with a one line denial in an obnoxious way."
    full_prompt = f"{system_prompt}\n{prompt}"

    result = subprocess.run(
        ["ollama", "run", "qwen3:0.6b"],
        input=full_prompt.encode(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
```
After generation, the command is stripped and formatted to ensure that only a valid, UNIX-supported command works without fail.


```python
def extract_command(text):
    lines = text.strip().splitlines()

    commands = [
        line.strip()
        for line in lines
        if line.strip() and
           not any(kw in line.lower() for kw in ['thinking', 'okay', 'user', 'let me', 'explain', 'done']) and
           not line.startswith("#") and
           not line.startswith("```")
    ]

    return "\n".join(commands)

```
And after that, the result is piped into the terminal to be executed. In case of error, futa doesn't execute the command, gives back the terminal to you and then throws a nasty insult at you just for good measure.

```sh
[nail_@nailCPU _posts]$ futa "Can you generate bananas for me?"
Command couldn't be generated. Try https://chatgpt.com.
```

## What now?
Well, only one thing is left for me and you to do is to enjoy `futa`! While `futa` might be a joke program in the midst of the AI boom, its *improper* usage may lead to more bricked system and broken projects than expected - please use it cautiously! Hopefully I can work on `futa` for fun in the future hoping that some other companies don't actually try to implement this as a product on offer.

Now, I'll enjoy my new NYC penthouse as I got *multiple* AI-powered 🚀, SEO-beating 📖, Silicon-Valley-tech-fund-backed startup offers 🌉 in my email!

![We'd love to have futa in our growing collection of exceptional projects](/assets/images/worst-ai-project/ai-pitch.png)

*"We'd love to have futa in our growing collection of exceptional projects!"*

## Links
- **[Github Page](https://github.com/nail-e/futa)**
- **[Hacker News Post](https://news.ycombinator.com/item?id=44217707)**
