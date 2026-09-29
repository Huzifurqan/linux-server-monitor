#!/bin/bash
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
