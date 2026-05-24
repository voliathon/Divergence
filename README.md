#  Divergence
[![version](https://img.shields.io/badge/version-2.1.3-blue.svg)](https://github.com/Voliathon/divergence)
[![author](https://img.shields.io/badge/author-Voliathon-lightgray.svg)](https://github.com/Voliathon)

A lightweight Windower addon for **Final Fantasy XI** that displays the current and upcoming schedules for Dynamis Divergence zones.

Never miss an open window again! This addon calculates the static 2-hour JST-based schedule for all four zones, directly in your chat log.

***

## 🚀 Features

* **JST Synced:** All times are synced to the official 0:00 JST schedule, regardless of your local time zone and rely on your System Clock.
* **Exact Times:** Tells you the *exact JST time* of the next window change (e.g., "Closes at 14:30").
* **At-a-Glance Status:** Shows only the *current* status, removing clutter.
* **Clear & Clean:** A simple, color-coded output makes it easy to read.
* **Lightweight:** No complex libraries or dependencies. Just one file.

***

## ⚙️ Installation

1.  Navigate to your Windower addons folder (usually `Windower4/addons/`).
2.  Create a new folder named `Divergence`.
3.  Inside that folder, create a new file named `Divergence.lua`.
4.  Copy and paste the entire contents of the `Divergence.lua` file into your new file.
5.  Save the file.
6.  In-game, run the command `//lua r divergetimes` or restart Windower.

***

## ⌨️ How to Use

Simply type the following command in-game:

```
//divtimes
   or
//div   
```

Example Output

This will print a tidy, color-coded schedule to your local chat log (using color code 207):
```

*** Divergence Shared Schedule (Current time in Japan(JST): 04:30) ***
 | San d'Oria  : Ongoing (30 minutes remaining) - Closes at 05:00
 | Bastok      : Ongoing (60 minutes remaining) - Closes at 05:30
 | Windurst    : Closed for (30 more minutes) - Opens at 05:00
 | Jeuno       : Closed for (60 more minutes) - Opens at 05:30

```

## Zone names are colored

1.  San d'Oria - Pink 
2.  Bastok - Blue 
3.  Windurst - Lime Green  
4.  Jeuno - White
5.  Ongoing is colored <font color="green">Green</font>.
6.  Closed for is colored <font color="gray">Gray</font>.

⚖️ Copyright

Copyright (c) 2025 Voliathon

This addon is for personal use and may be freely distributed and modified, provided this copyright notice remains intact.
