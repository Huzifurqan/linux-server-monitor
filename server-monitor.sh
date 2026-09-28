#!/bin/bash
log() {
    level="$1"
    shift
    message="$*"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp $level $message" | tee -a logs/monitor.log
}

disk_usage=$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')

if [[ $disk_usage -gt 80 ]]
then
	 log WARNING "Disk usage: ${disk_usage}% (threshold ${DISK_WARN}%)"
else
	 log INFO "Disk usage: ${disk_usage}%"
fi
