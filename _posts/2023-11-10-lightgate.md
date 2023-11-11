---
title: "Creating an Arduino-Powered Lightgate"
date: 2023-04-13T00:00:00+00:00
author: Elian Rieza
layout: post
permalink: /creating-an-arduino-powered-lightgate/
categories: Hardware
tags: [arduino, physics, hardware]
---
A high-school project never really warrants any extra brainpower required, especially if it's ungraded and for competition but the time constraints and team pressure makes an absolutely great learning experience. Last month, my IB school decided to run a Group 4 project day(s) and well, other than the redundancy of an optional, 6-hour project stretched out to two days, the Arduino project went well for our group.

The prompt for the project was to create systems for a city on Mars and our group came up with a transportation system that would speed through Martian planes in a hyperloop-esque system. As the "Computer Scientist" and "Physicist" of the group, I was tasked with creating a monitoring system for the hyperloop speeds and thus came the idea of creating a lightgate.

<img src="/assets/images/lightgate-post/real.jpg" alt="Arduino Lightgate" title="Lightgate" style="width:500px; height:300px; margin-right:20px; float: left;">

A lightgate usually comes in pairs and is hooked up to a datalogger to either read the speed, velocity, acceleration or time between passing lightgates. To register a lightgate reading, the lightgate's light sensor reading would usually deviate enough to suggest that an object has passed through the lightgate. Standard stuff.

The project required calculating the speed of a train through the model tunnel, so fortunately for me, only one light sensor's reading is required (thankfully). The KY-018 photoresistor module acts as the lightgate's sensor. An LCD display also outputs the speed of the object passing through the tunnel.

I attached the photoresistor to the two female-to-male connectors so that the photoresistor sensor head could be placed in a cardboard tube in the model.


It seemed appropriate for female-to-male connectors could be used on the LEDs to allow it to be connected on the top of the cardboard tube for easier viewing (and also a more polished model).

<img src="/assets/images/lightgate-post/FTM2.jpg" alt="Arduino Lightgate" title="Lightgate" style="width:500px; height:300px; float: right; margin-left:20px">

In the end, I sided with it as I was planning to exhibit the model headless and my group really didn't want to lug around a behemoth of a gaming laptop just for this one exhibition.

The code for the board should first check the average reading of the first 10 readings to get the mean reading of the brightness. This allows for any negative deviations to register as the lightgate being used. As one photoresistor is attached, the length of the object planned to pass through the lightgate must be declared (in <span class="unit">km ⋅ h</span> <sup class="superscript">-1</sup> ) to get an accurate speed reading so as the photoresistor's digital value gets lower than a certain average threshold, a digital timer will start to calculate the time taken for the object to pass then the value is converted into hours. After this, the final value should be displayed on the LCD.

This is when I realized that I was missing a potentiometer. I couldn't find one in time so I decided to output the speed calculations on the computer instead and only use the LCD as a proof-of-concept. But all-in-all, writing the software for it was a breeze. The timer module for Arduino is an absolute godsend, using only two functions to be able to calculate time taken. I highly recommend it for anyone needing a timer function for Arduino. 

{% highlight c %}
// This code comes from GitHub page
#include <LiquidCrystal.h> 

LiquidCrystal lcd(12, 11, 5, 4, 3, 2); 
int threshold = 150;                      	  
const int count = 500; 
int readings[count];   
int readIndex, total, photoresistor; 
int length = 0; // Length of object passing thru tube in meters

void setup() { 
  Serial.begin(9600);          	  
  lcd.begin(16,2); 
  lcd.clear(); 
  for (int i = 0; i < count; i++) { 
    readings[i] = 0; 
  } 
} 

void loop() { 
  total = total - readings[readIndex]; 
  readings[readIndex] = analogRead(A0); 
  total = total + readings[readIndex]; 
  readIndex = readIndex + 1;
  if (readIndex >= count) { 
    readIndex = 0;
  } 

  photoresistor = analogRead(A0);    
  Serial.println(photoresistor);     
  
  if (photoresistor < threshold) { 
    lcd.clear(); 
    lcd.setCursor(0,0); 
    lcd.print("Lightgate Closed"); 
    lcd.setCursor(0,1); 
    lcd.print(length / readIndex);
    lcd.setCursor(5,1); 
    lcd.print("m/s"); 
  } 

  else { 
    lcd.setCursor(0,0); 
    lcd.print("Lightgate Clear "); 
    readIndex = 0; 
  } 
  delay(100);               	  
} 

{% endhighlight %}

## Future Stuff 
One glaring issue was the concession I made with the average reading. While this probably could've been easily fixed by writing each value to an array of 10, time constraints (and severe procrastination) hampered it. It probably could've been added in 10 mins with an extra 10 minutes just for testing.

Lightgates are also usually upright but this one's upside down. Lab-grade lightgates use invisible lasers to calculate when and how fast an object breaks or shortens a laser's length so an analog sensor is caveman technology compared to a lab-grade lightgate.

Another problem is how the timer was counted. If I were creating this in a non-Arduino environment, my first instinct would've been using difference in Unix time but I found as I found a solution in the Timer module, which is way easier than Unix time difference. Timer isn't super efficient though, with a few tests showing different values for the same delay time but I guess 5 decimal places don't really matter.

## Links
- **[Github Page](https://github.com/nail-e/arduino-lightgate)**
- **[Project Gallery](https://github.com/nail-e/arduino-lightgate/tree/main/Gallery)**

