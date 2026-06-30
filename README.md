# Server Performance Stats Script

A lightweight, portable Bash shell script designed to analyze and display essential Linux server performance statistics in a clean, human-readable dashboard. 

This script relies entirely on standard built-in Linux utilities, making it compatible with almost any modern Linux distribution without requiring external monitoring packages.

## Features

### Core Metrics
* **Total CPU Usage:** Calculates actual real-time CPU utilization via `/proc/stat` deltas.
* **Memory Usage:** Displays Total, Used, and Free memory in Megabytes along with percentage usage.
* **Disk Usage:** Provides a breakdown of total storage capacity, current utilization, and remaining free space.
* **Top 5 Processes by CPU:** Identifies resource-heavy applications sorted by CPU consumption.
* **Top 5 Processes by Memory:** Identifies resource-heavy applications sorted by RAM consumption.

### System & Security Extras (Stretch Goals)
* **OS Version:** Detects the specific flavor and version of the Linux environment.
* **System Uptime:** Shows how long the machine has been running.
* **Load Average:** Captures standard system load averages (1, 5, and 15-minute intervals).
* **Active Users:** Counts currently logged-in user sessions.
* **Security Auditing:** Parses system authentication logs to extract the count of failed login attempts.

---

## Installation & Setup

1. **Clone or Download the Script**
   Save the script as `server-stats.sh` onto your target Linux machine.

2. **Make the Script Executable**
   Before running the script, you must grant it execution permissions:
   ```bash
   chmod +x server-stats.sh
