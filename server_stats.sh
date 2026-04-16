# !/bin/bash
# server_stats.sh - Basic Linux performance monitor

echo "=== Server Performance report ==="


CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
CPU_USED=$(awk "BEGIN {printf \"%.1f%%\", 100-$CPU_IDLE }")
echo "🔹 CPU Usage: $CPU_USED"