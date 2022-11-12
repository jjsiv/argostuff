#!/bin/bash

cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
gpu_temp=$(vcgencmd measure_temp | grep -Po '\d{2}')
df_str=$(df -h --type=ext4 --output=size,used,avail,pcent | tail -n 1)
mem_str=$(free -m | head -n 2 | tail -n 1)
timestamp=$(date +%d-%m-%YT%T)
node_name=$(hostname)

# Convert str to array
df_arr=($df_str)
mem_arr=($mem_str)

json_template='
	{"timestamp":"%s","node":"%s","data":{
		"cpu_temp":"%s","gpu_temp":"%s",
		"memory":{"total":"%s","used":"%s","available":"%s"},
		"disk":{"size":"%s","used":"%s","available":"%s","percent":"%s"}}}\n'

# df_arr elements:
# 0 = size, 1 = used, 2 = available, 3 = used %
# mem_arr elements:
# 1 = total, 2 = used, 3 = free, 4 = shared, 5 = buff/cache, 6 = available
# using "free" because grepping from /proc/meminfo is not much better

json_out=$(printf "$json_template" \
	"$timestamp"               \
	"$node_name"               \
       	"$((cpu_temp / 1000))"     \
       	"$gpu_temp"	           \
	"${mem_arr[1]}Mi"          \
	"${mem_arr[2]}Mi"          \
	"${mem_arr[6]}Mi"          \
	"${df_arr[0]}"             \
        "${df_arr[1]}"             \
	"${df_arr[2]}"             \
	"${df_arr[3]}"             \
	)	

echo $json_out | jq
echo $json_out >> /home/jjk/results
#TODO run as a cronjob and send results to db