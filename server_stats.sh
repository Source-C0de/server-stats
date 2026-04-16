# !/bin/bash
# server_stats.sh - Basic Linux performance monitor

echo "=== Server Performance report ==="

# Cpu used 
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
CPU_USED=$(awk "BEGIN {printf \"%.1f%%\", 100-$CPU_IDLE }")
echo "🔹 CPU Usage: $CPU_USED"


# Memory Used
MEM_USED_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($3/$2)*100}')
MEM_FREE_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($4/$2)*100}')
echo " Memory: Used ${MEM_USED_PCT}% | Free ${MEM_FREE_PCT}%"

