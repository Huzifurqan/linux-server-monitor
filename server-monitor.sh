#!/bin/bash
set -uo pipefail

log() {
    level="$1"
    shift
    message="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp $level $message" | tee -a logs/monitor.log
}

disk_usage=$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')

if [[ $disk_usage -gt 85 ]]
then
	 log WARNING "Disk usage: ${disk_usage}% (threshold ${DISK_WARN}%)"
else
	 log INFO "Disk usage: ${disk_usage}%"
fi

#memory check

mem_total=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
mem_available=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
mem_usage=$(( (mem_total - mem_available) * 100 / mem_total ))

MEM_WARN=80
if [[ $mem_usage -gt $MEM_WARN ]]
then
    log WARNING "Memory usage: ${mem_usage}% (threshold ${MEM_WARN}%)"
else
    log INFO "Memory usage: ${mem_usage}%"
fi

#Cpu Check

read total1 idle1 <<< "$(awk '/^cpu / {idle=$5+$6; total=0; for(i=2;i<=NF;i++) total+=$i; print total, idle}' /proc/stat)"
sleep 1
read total2 idle2 <<< "$(awk '/^cpu / {idle=$5+$6; total=0; for(i=2;i<=NF;i++) total+=$i; print total, idle}' /proc/stat)"
total=$((total2 - total1))
idle=$((idle2 - idle1))
usage=$(( (total - idle) * 100 / total ))

cpu_warn=80
if [[ $usage -ge $cpu_warn ]]
then
     log WARNING "Cpu usage: ${usage}% (threshold ${cpu_warn}%)"
else
    log INFO "Cpu usage: ${usage}%"
fi

#ip address

ip_addr=$(hostname -I | awk '{print $1}')
ping -c 1 -W 2 8.8.8.8 > /dev/null
ping_result=$?
if [[ $ping_result -eq 0 ]]
then
    log INFO "Network: reachable (IP: $ip_addr)"
else
    log INFO "Network: not reachable (IP: $ip_addr)"
fi
