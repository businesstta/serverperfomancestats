#!/bin/bash

# ==============================================================================
# Script Name: server-stats.sh
# Description: Analyzes and displays basic Linux server performance statistics.
# ==============================================================================

# Text Formatting Delimiters
printf -v line '%*s' 50 ''; line=${line// /-}
printf -v double_line '%*s' 50 ''; double_line=${double_line// /=}

echo "$double_line"
echo "         SERVER PERFORMANCE STATISTICS"
echo "$double_line"

# --- STRETCH GOAL: OS & System Info ---
echo -e "\n### SYSTEM INFO ###"
echo "OS Version:      $(grep -w "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "Uptime:          $(uptime -p)"
echo "Load Average:    $(cat /proc/loadavg | awk '{print $1", "$2", "$3}')"
echo "Logged-in Users: $(who | wc -l)"

# --- CORE: Total CPU Usage ---
# Calculates CPU usage by capturing /proc/stat intervals
echo -e "\n### CPU USAGE ###"
cpu_stats1=( $(grep '^cpu ' /proc/stat) )
sleep 0.5
cpu_stats2=( $(grep '^cpu ' /proc/stat) )

# Idle time = idle + iowait
idle1=$((cpu_stats1[4] + cpu_stats1[5]))
idle2=$((cpu_stats2[4] + cpu_stats2[5]))

# Total time = sum of all fields
total1=0; for i in "${cpu_stats1[@]:1}"; do total1=$((total1 + i)); done
total2=0; for i in "${cpu_stats2[@]:1}"; do total2=$((total2 + i)); done

diff_idle=$((idle2 - idle1))
diff_total=$((total2 - total1))
cpu_usage=$(awk "BEGIN {print (1 - $diff_idle / $diff_total) * 100}")

printf "Total CPU Usage: %.2f%%\n" "$cpu_usage"

# --- CORE: Total Memory Usage ---
echo -e "\n### MEMORY USAGE ###"
free -m | awk '
NR==2 {
    total=$2; used=$3; free=$4;
    percent=(used/total)*100;
    printf "Total/Used/Free: %dMB / %dMB / %dMB\n", total, used, free
    printf "Usage Percentage: %.2f%%\n", percent
}'

# --- CORE: Total Disk Usage ---
echo -e "\n### DISK USAGE ###"
df -h --total | awk '
END {
    printf "Total/Used/Free: %s / %s / %s\n", $2, $3, $4
    printf "Usage Percentage: %s\n", $5
}'

# --- CORE: Top 5 Processes by CPU Usage ---
echo -e "\n### TOP 5 PROCESSES BY CPU USAGE ###"
printf "%-8s %-10s %-10s %-20s\n" "PID" "USER" "%CPU" "COMMAND"
echo "$line"
ps -eo pid,user,%cpu,cmd --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "%-8s %-10s %-10s %-20s\n", $1, $2, $3, $4}'

# --- CORE: Top 5 Processes by Memory Usage ---
echo -e "\n### TOP 5 PROCESSES BY MEMORY USAGE ###"
printf "%-8s %-10s %-10s %-20s\n" "PID" "USER" "%MEM" "COMMAND"
echo "$line"
ps -eo pid,user,%mem,cmd --sort=-%mem | head -n 6 | tail -n 5 | awk '{printf "%-8s %-10s %-10s %-20s\n", $1, $2, $3, $4}'

# --- STRETCH GOAL: Security Info ---
echo -e "\n### SECURITY INFO ###"
# Check common auth log paths for failed entries
if [ -f /var/log/auth.log ]; then
    failed_logins=$(grep -i "failed" /var/log/auth.log | wc -l)
elif [ -f /var/log/secure ]; then
    failed_logins=$(grep -i "failed" /var/log/secure | wc -l)
else
    failed_logins="N/A (Logs restricted or not found)"
fi
echo "Failed Login Attempts: $failed_logins"
echo "$double_line"
