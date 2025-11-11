#  divergence-times
[![version](https://img.shields.io/badge/version-1.0.1-blue.svg)](https://github.com/Voliathon/divergence-times)
[![author](https://img.shields.io/badge/author-Voliathon-lightgray.svg)](https://github.com/Voliathon)

A lightweight Windower addon for **Final Fantasy XI** that displays the current and upcoming schedules for Dynamis Divergence zones.

Never miss an open window again! This addon calculates the static 2-hour JST-based schedule for all four zones, directly in your chat log.

***

## 🚀 Features

* **JST Synced:** All times are synced to the official 0:00 JST schedule, regardless of your local time zone and rely on your System Clock.
* **2-Hour Forecast:** Instantly see the current status and the next two upcoming windows for every zone.
* **Clear & Clean:** A simple, color-coded output makes it easy to read at a glance.
* **Lightweight:** No complex libraries or dependencies. Just one file.

***

## ⚙️ Installation

1.  Navigate to your Windower addons folder (usually `Windower4/addons/`).
2.  Create a new folder named `DivergenceTimes`.
3.  Inside that folder, create a new file named `DivergenceTimes.lua`.
4.  Copy and paste the entire contents of the `DivergenceTimes.lua` file into your new file.
5.  Save the file.
6.  In-game, run the command `//lua r divergetimes` or restart Windower.

***

## ⌨️ How to Use

Simply type the following command in-game:

```sh
//divtimes
```
*(You can also use the alias: `//div`)*

### Example Output

This will print a tidy, color-coded schedule to your local chat log (using color code 207):

```
---------- Divergence Schedule (JST: 04:30) -----------
------- San d'Oria  : Open (30m) > Closed (60m) > Open (60m)-------
------- Bastok      : Open (60m) > Closed (30m) > Closed (30m)-------
------- Windurst    : Closed (30m) > Open (60m) > Closed (60m)-------
------- Jeuno       : Closed (60m) > Open (30m) > Open (30m)-------```
```

* **Open** is colored <font color="green">**Green**</font>.
* **Closed** is colored <font color="gray">**Gray**</font>.

***

## ⚖️ Copyright

Copyright (c) 2025 Voliathon

This addon is for personal use and may be freely distributed and modified, provided this copyright notice remains intact.
