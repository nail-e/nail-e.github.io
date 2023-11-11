---
title: "In search of Amongi using Rust and Chudnovsky's Algorithm"
date: 2023-10-13T00:00:00+00:00
author: Elian Rieza
layout: post
permalink: /in-search-of-amongi-using-rust-and-chudnovskys-algorithm/
categories: Software
tags: [software, math, coding, rust]
mathjax: true
---
Pi has always been 3.14159 to me and to everyone else really, it's only nerds who'd want to know pi up to its 100th or 1000th digit while its your supernerds who'd be searching for pi up to the millionth digit and well, I'm a supernerd (when I want to).

So I was bored one summers day and way too done with the monotony of math and physics revision and opened up YouTube and the first video that piqued my interest was Stand-Up Math's legendary video of finding Among Us in Pi. This Einsteinian ingenuity of a video warrants its own place in the annals of history for finding the meaning of life, death and everything in between but also raised a question in my head: how many Amongi are there in pi?

It's 4.

Anyways, the code consisted of a function converting the first million digits of pi (removing the `3`.) into binary then writing the binary output to a text file. Another function read from the file to search for the string "0111110011110101" or "1010111100111110". This was quite easy but it led me to a much cooler discovery.

## Chudnovsky's Algorithm
Chudnovsky's Algorithm was formulated by the Chudnovsky brothers in 1988 based on Ramanujan's pi formulae and goddamn is it interesting. I'm no mathematician but I'll attempt to explain it the best I can.

So, using a generalized hypergeometric function: 

$$\begin{equation} _pF_q\left( \begin{array}{c} a_1, a_2, \ldots, a_p \\ b_1, b_2, \ldots, b_q \end{array}; z \right) = \sum_{n=0}^{\infty} \frac{(a_1)_n (a_2)_n \cdots (a_p)_n}{(b_1)_n (b_2)_n \cdots (b_q)_n} \frac{z^n}{n!} \end{equation}$$

The Chudnovsky algorithm uses the 9th Heegner number ($-163$) which is an integer which is divisible by no square number other than 1 and is part of a finite field of imaginary numbers as well as the $j$-function which is a function of a complex variable on the imaginary, positive-only plane (also known as the upper-half plane) of complex numbers to result in: 

$$\pi = 426880 \sqrt{10005} \sum_{k=0}^{\infty} \frac{(6k)!(545140134k + 13591409)}{(3k)!(k!)^3(-262537412640768000)^k}$$

This is the Chudnovsky's algorithm which probably works on a graphing calculator or on pen and paper but it needs some work to be applied on Rust. More on this later.

## My Attempt
I've recently become enticed with Rust and its intricacies, almost unhealthily as well. It's speed and simplicity paired with how readable it is. It's like if you took C's control, power and processing and took Python's syntax and readability and created a love child. 

Again, I'm no mathematician, so translating mathematical equations into code was a bit daunting. However, Rust's made the process more manageable. In crafting this implementation, I began by initializing variables to accommodate the dynamic nature of Chudnovsky's algorithm. Using `Float` type from `rug` - a library for large numbers operations - helps with precise calculations for longer numbers. 

{% highlight rust %}
// From lib.rs. File available on GitHub

#![warn(clippy::all, clippy::pedantic, missing_docs)]

use rug::{ops::Pow, Float};

#[must_use]
pub fn pi(prec: u32, its: u32) -> Float {
    // Define the constants
    const A: u32 = 42_68_80;
    const B: u32 = 10_005;
    const K: u32 = 6;
    const K_S: u32 = 12;
    const L: u32 = 13_59_14_09;
    const L_S: u32 = 545_140_134;
    const M: u32 = 1;
    const X: u32 = 1;
    const X_S: i64 = -262_537_412_640_768_000;
    const S: u32 = 0;

    // Initialize the values
    let a = Float::with_val(prec, A);
    let b = Float::with_val(prec, B).sqrt();
    let c = Float::with_val(prec, &a * &b);
    let mut k = Float::with_val(prec, K);
    let k_s = Float::with_val(prec, K_S);
    let mut l = Float::with_val(prec, L);
    let l_s = Float::with_val(prec, L_S);
    let mut m = Float::with_val(prec, M);
    let mut x = Float::with_val(prec, X);
    let x_s = Float::with_val(prec, X_S);
    let mut s = Float::with_val(prec, S);

    // Iterate
    for q in 0..its {
        // S = S + M_q * L_q / X_q
        s += Float::with_val(prec, &m * &l) / &x;

        // M_q = M_q * (K_q^3 - 16 * K_q) / (q + 1)^3
        m *= (k.clone().pow(3) - 16 * k.clone()) / Float::with_val(prec, (q + 1).pow(3));

        // Update K_q, L_q, and X_q
        k += &k_s;
        l += &l_s;
        x *= &x_s;
    }

    // C * (1 / S)
    s = Float::with_val(prec, 1) / &s;

    // Pi
    Float::with_val(prec, &c) * &s
}
{% endhighlight %}

Chudnovsky's algorithm constantly interates, each progressively searching the approximation of pi and two fundamental things that Rust achieved was accuracy and speed. Rust's `Float` ensures that every operation maintains point-bit precision up to 64 bits.

{% highlight rust %}
// From main.rs. File available on GitHub

mod lib;

use lib::pi;
use std::env;

// Edit this for precision
const PRECISION: u32 = 1000000;

// Default number of iterations
const ITERATIONS: u32 = 1;

fn main() {
    // Command line arguments
    let args: Vec<_> = env::args().collect();

    // Make decisions based on the number of arguments
    match args.len() {
        1 => {
            println!("Approximation: {:?}", pi(PRECISION, ITERATIONS));
            println!("Precision:     {:?}", PRECISION);
            println!("Iterations:    {:?}", ITERATIONS);
        }
        2 => {
            let precision = args[1]
                .parse::<u32>()
                .expect("Precision must be a positive integer!");
            if precision <= 0 {
                panic!("Precision must be a positive integer!");
            } else {
                println!("Approximation: {:?}", pi(precision as u32, ITERATIONS));
                println!("Precision:  {:?}", precision);
                println!("Iterations: {:?}", ITERATIONS);
            }
        }
        3 => {
            let precision = args[1]
                .parse::<u32>()
                .expect("Precision must be a positive integer!");
            let iterations = args[2]
                .parse::<u32>()
                .expect("Number of iterations must be a positive integer!");
            if precision <= 0 {
                panic!("Precision must be a positive integer!");
            } else if iterations <= 0 {
                panic!("Number of iterations must be a positive integer!");
            } else {
                println!(
                    "Approximation: {:?}",
                    pi(precision as u32, iterations as u32)
                );
                println!("Precision:  {:?}", precision);
                println!("Iterations: {:?}", iterations);
            }
        }

        _ => panic!("Redundant argument."),
    }
}

{% endhighlight %}

To enhance utility, this thing runs on CLI using `env`, allowing to specify the desired precision and number of iterations as straightforward command line arguments. Moreover, basic error handling exists, ensuring that a user can't shoot themselves in the foot.

{% highlight bash %}
[nail_@nailCPU src]$ cargo run 1000 1
warning: found module declaration for lib.rs
  --> src/main.rs:14:1
   |
14 | mod lib;
   | ^^^^^^^^
   |
   = note: lib.rs is the root of this crate's library target
   = help: to refer to it from other targets, use the library's name as the path
   = note: `#[warn(special_module_name)]` on by default

warning: `chudnovskys-amongii` (bin "chudnovskys-amongii") generated 1 warning
    Finished dev [unoptimized + debuginfo] target(s) in 0.16s
     Running `/home/nail_/Documents/Programming/chudnovskys-amongii/target/debug/chudnovskys-amongii 1000 1`
Approximation: 3.1415926535897342076684535915782983407622332609157065908941454987376662094016591080661173
47469689757798160379655566278035801345995935132861731766159828062231080441973785312530565152115747085933831
77441545774415459602274587627712846591418133739922859535784112988088378242126794689633529216676947336619680
7151594471515944
Precision:  1000
Iterations: 1

{% endhighlight %}

It's not perfect sure, but it sure does work. This small project really helped me wrap my head around Rust and Math (even though Math is a fluke in school) so go ahead and give it a try! 

## Links
- **[Github Page](https://github.com/nail-e/chudnovskys-amongii)**
- **[Rug Library](https://docs.rs/rug/latest/rug/)**
- **[Stand-Up Math's Video](https://www.youtube.com/watch?v=dET2l8l3upU)** 

