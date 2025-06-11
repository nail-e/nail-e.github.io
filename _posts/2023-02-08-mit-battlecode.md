---
title: "MIT Batttlecode 2023: An unofficial Postmortem by cattleboys (Ram Ranch Cowboys)"
layout: post
permalink: /posts/mit-battlecode-2023-unofficial-postmortem/
---

High School competitions are way more competitive than they should be, yet there still is a spirit that can't be explained when you're in one. Shaun Gallevo (Heriott-Watt '28), Harshit Singhal (Georgia Tech '28), Faisal Al-Ruwaili (Warwick '27), Sina Ibrahimi and I (Elian Rieza, Purdue '28) competed in MIT Battlecode 2023 as **cattleboys** (previously **Ram Ranch Cowboys**). Overall, we finished #101 in the entire competition while we placed #1 in the International High School division. It was a good start for our team especially the fact that it was the first High School hackathon for the most of us. Pretty impressive start. 

Overall, we created five different generational machine-learning bots; Alpha, Barry, Celeste, Dante and Jimmy - with the latter leading us to our final position. Each one was was an iteration over the previous one, with Jimmy being the fifth and cumulative bot out of all of the five bots. Our progress can be seen on the [Github Page](https://github.com/nail-e/battlecode-tempest-2023) where we open sourced our code.

## Stratgem Overview 
The five bots all shared a core program provided by the Battlecode Team called examplefunsplayer. Each of these bots served a specific role, however. Alpha was our starting template; Barry was our main tournament bot, Celeste was a hyper-aggressive version of Barry, Dante was our sandbox while Jimmy was a late-game introduction based on Celeste to explore scaling and endgame control

### An overview of Alpha (aka examplefuncsplayer)
Alpha is essentially the default bot provided by the Battlecode starter package. We used it as a baseline reference for validating engine updates, API behavior, and the correctness of our shared memory logic. It’s a stripped-down bot that only includes Soldiers, HQ, and a rudimentary Launcher.

We left Alpha mostly unchanged from the starter files but we occasionally added simple logging or forced deterministic behavior for debugging. The bot runs without a centralized communication protocol and makes independent decision based purely on local sensing. Each robot class (`HQ.java`, `Soldier.java`, etc.) is procedural.

```java
public class RobotPlayer {
    public static void run(RobotController rc) throws GameActionException {
        switch (rc.getType()) {
            case HQ -> HQ.run(rc);
            case LAUNCHER -> Launcher.run(rc);
            default -> Soldier.run(rc);
        }
    }
}
```

We didn’t use any encoding/decoding systems or location utilities in Alpha. Instead, it functions as a control group when testing behaviors of more complex bots. Admittedly, Alpha wasn't built to win but it was a start. This was the pre-scrimmage rounds so we had more time to put into the next iteration before we could start.

### An overview of Barry 
Barry is our main submission bot. It represents the culmination of several design experiments around movement, anchor control, coordinated combat, and resource management. Barry uses Carriers to expand and secure anchors and Launchers to defend and apply map pressure. It features layered communication through shared memory and role-aware behavior in each unit.

We used a clean dispatcher in RobotPlayer.java to assign control to individual role classes, such as Barry.HQ, Barry.Carrier, and Barry.Launcher. Each robot uses a shared logging and debug framework that we custom built for Barry, allowing us to selectively activate or suppress logs for performance reasons.

We implemented our own Comms system which uses shared array channels for structured communication. Locations were encoded using helper methods like:
```java
public class RobotPlayer {
  public static void run(RobotController rc) throws GameActionException {
        rc.setIndicatorString("Hello world!");
        birthRound = rc.getRoundNum();
        Log.rc = rc;
        MY_TEAM = rc.getTeam();
        OPPONENT = MY_TEAM.opponent();

        while (true) {

            try {
                switch (rc.getType()) {
                    case HEADQUARTERS:      Headquarters.run(rc);   break;
                    case CARRIER:           Carrier.run(rc);        break;
                    case LAUNCHER:          Launcher.run(rc);       break;
                    case BOOSTER:           Booster.run(rc);        break;
                    case DESTABILIZER:      Destabilizer.run(rc);   break;
                    case AMPLIFIER:         Amplifier.run(rc);      break;
                }

                if (printBytecode) {
                    Log.println(rc.getType() + " bytecode " + rc.getLocation() + " $" + Clock.getBytecodesLeft());
                }
            } catch (GameActionException e) {
                System.out.println(rc.getType() + " Exception");
                e.printStackTrace();

            } catch (Exception e) {
                System.out.println(rc.getType() + " Exception");
                e.printStackTrace();

            } finally {
                Clock.yield();
                turnCount += 1;  // We have now been alive for one more turn!
            }
        }

    }
}
```

We built robust communication protocols which allowed important game state changes to be announced and propagated. We also included the unit compositon and the Anchor encoder to determine the location of the anchor. 

```java
public static void encodeAnchor(MapLocation anchorLoc) {
    // Broadcast anchor in shared array
    int encoded = anchorLoc.x * 60 + anchorLoc.y;
    rc.writeSharedArray(ANCHOR_CHANNEL, encoded);
}

```

Barry was the reason we stayed stable at ~1500 rating for most of the tournament. We probably could've benefitted from more of improving on the logic of Barry and increasing its tactical operations rather than its aggressiveness.

### An overview of Celeste 
Celeste helped us improve Barry’s early-game survivability. It reduced our rating by a sharp amount, but it shaped how Barry responded to rush strategies, especially before the International qualifiers. Specifically, it helped its agression in unranked scrims and improved on Barry's HQ prioritiation. We also used some of the ranked scrims to determine how useful the bots are for handling early-game stress.

We forked Barry's structure but removed much of the carrier logic. Instead, the HQ immediately began to spawn Launchers:

```java
if (rc.canBuild(RobotType.LAUNCHER)) {
    rc.build(RobotType.LAUNCHER);
}
```
We reduced reliance on shared memory and built a simplified target acquisition system. Celeste Launchers essentially check for enemies in sensor range and attack directly. We did not implement ally-avoidance logic in Celeste; it was expected to operate in sparse maps where friendly fire was less likely.

The movement system was very basic. If an enemy HQ was discovered, the Launcher would path directly toward it with greedy movement:

```java
if (rc.canMove(dir)) {
    rc.move(dir);
}
```

The changes were very minimal, it was not sustainable in the endgame but succeeded in exposing poor spawn logic or economic plays by the bots through game state changes.

### An overview of Dante 
Dante was our platform for prototyping advanced tactics and speculative algorithms. We used Dante to test communication encoding schemes, coordinated pathfinding, and map memory. Many of these features were too expensive or unreliable to ship in Barry, but Dante gave us a place to test them in isolation.

Dante’s dispatcher has `SmartCarrier` and `PredictiveLauncher` which were methods that attempted to implement a predictive algorithm based on previous enemy patterns. We experimented with shared memory optimizations by reducing total writes per round using timestamps and differential updates.

We also experimented with a quadrant-based map grid, encoding enemy density:
```java
rc.writeSharedArray(17, encodeEnemyCluster(enemyLoc));
```
Another key experiment was predictive movement. We tested algorithms to predict enemy movement vectors and aim Launchers accordingly, but this was bytecode-intensive and often unreliable. Additionally, we experimented with situational anchor scoring. Anchors were scored by distance to spawn, distance to enemy HQ, and number of adjacent passable tiles. This allowed us to test priority-based claiming strategies.

Overall, the only changes we pushed from Dante to Barry were the prediction algorithms which helped us set our movements early on in the game and helped us compete when our Bot started to lose against teams who've evolved.

### An overview of Jimmy
Jimmy is a defensive, economic-oriented bot that focuses on scaling through part collection and anchor capture. It delays combat units and focuses on winning through resource advantage and control of islands. We designed Jimmy's HQ to favor Carriers heavily - a very different approach compared to Barry and Celeste. 

```java
if (rc.canBuild(RobotType.CARRIER)) {
    rc.build(RobotType.CARRIER);
}
```
Each Carrier followed a simple exploration routine based on edge-following and random walk within bounds. When parts were found, they collected them immediately:

```java
if (rc.senseParts(currentLoc) > 0 && rc.canCollectParts()) {
    rc.collectParts();
}

```
Jommy also has a passive anchor system. If a carrier found an uncontested anchor and no enemies near by, it would pick it up.

```java 
if (anchorAvailable && !underThreat) {
    rc.pickupAnchor();
}
```

We reduced shared memory use to a bare minimum in Jimmy. It relied on implicit behavior rather than coordination, which reduced overhead but also limited adaptability. Jimmy tested whether passive scaling alone could win games. While it performed well in maps without strong rush bots, it consistently failed against aggressive opponents. However, it provided a useful lower bound for required defense and helped define the balance point between economy and attack.

## Performance
Overall, according to the [results](https://jmerle.github.io/battlecode-2023-statistics/), Barry helped us peak at around ~1700 but stabilized at ~1500 by the time the high school ranked scrimmages started. 

![RRC-battle-coderesults](/assets/images/battlecodee-2023/results.png)

From the start, it seemed that bot Alpha only peaked at around 12 matches won out of 38 matches played overall prior to sprint 2. Once we pushed Barry post-sprint 2, we saw a sudden spike in rating from the defualt of 1000 up to 1349 and once more up to exactly 1712 (peak rank) until we reduced and plateaued at 1500. Celeste seemed to result in a steep decline from 1487 to 1476 over the weekend of the competition but once we pushed the changes in Jimmy and Dante to Barry, our score peaked and lowered at the 1500 mark until we reached 1544 at the end of the competition.

## Conclusion
One of the largest things we learned in the competition was that strategy takes precendence over implementation. Half of our methods could've been introduced using simple `if` statements, very lightweight too. None of our implementations were of a complex nature yet half of our strategy worked in our limited programming capabilities. 

If we had more time, we would invest in a more dynamic pathfinding solution and better movement coordination between units. We would also continue to integrate the best elements from Dante into Barry incrementally, rather than running them in isolation.

All in all, MIT Battlecode 2023 was a good introduction to hackathons and our final ranking isn't much but its a commendable position. 

## Links
- **[Github Page](https://github.com/nail-e/battlecode-tempest-2023)**
- **[2023 Stats](https://jmerle.github.io/battlecode-2023-statistics/)**

