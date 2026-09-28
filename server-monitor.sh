#!/bin/bash
disk_usage=$(df -P / | awk 'NR==2 {gsub("%", "", $5); print $5}')

if [[ $disk_usage -gt 80 ]]
then
	echo "$disk_usage% WARNING!! Low Storage"
else
	echo "Storage is fine $disk_usage% "
fi
