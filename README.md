# Linux Server Monitor

A Bash-based tool that checks CPU, memory, disk, and network health on a Linux server, logs results, and runs as a Docker container.

## Features
- Disk, memory, CPU, and network checks with configurable warning thresholds
- Timestamped logging to `logs/monitor.log`
- Interactive menu to run individual checks or all at once
- Dockerized for portable deployment

## How it works
[2-3 sentences: e.g. "CPU usage is calculated by sampling /proc/stat twice, one second apart, since it only reports cumulative time since boot..."]

### Run locally
git clone https://github.com/Huzifurqan/linux-server-monitor.git
cd linux-server-monitor
chmod +x bin/server-monitor.sh
./bin/server-monitor.sh

### Run with Docker
docker pull YOUR_DOCKERHUB_USERNAME/linux-server-monitor:latest
docker run -it YOUR_DOCKERHUB_USERNAME/linux-server-monitor:latest

## Sample output
=== Linux Server Monitor ===
1) Check Disk
2) Check Memory
3) Check CPU
4) Check Network
5) Run All Checks
6) Exit
   
Choose an option: 5

2026-09-29 21:09:45 INFO Disk usage: 18%
2026-09-29 21:09:45 INFO Memory usage: 45%
2026-09-29 21:09:46 INFO Cpu usage: 4%
2026-09-29 21:09:46 INFO Network: reachable (IP: 127.0.1.1)


## What I learned
[2-4 bullets — real technical lessons, e.g.:]
- CPU usage can't be read from a single /proc/stat sample; it requires two readings and a delta calculation
- Alpine's BusyBox `hostname` doesn't support GNU flags like `-I`, requiring `-i` instead
- MemAvailable is a more accurate usage metric than MemFree, which excludes reclaimable cache

## Tech stack
Bash, Docker, Linux (`/proc`, `df`, `awk`)
