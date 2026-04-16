# !/bin/bash
# server_stats.sh - Basic Linux performance monitor
# Usage: ./server_stats.sh

# ANSI Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo "       🖥️  SERVER PERFORMANCE REPORT       "
echo "========================================${NC}"

# Cpu used 
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
CPU_USED=$(awk "BEGIN {printf \"%.1f%%\", 100-$CPU_IDLE }")
echo "🔹 CPU Usage: $CPU_USED"


# Memory Used
MEM_USED_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($3/$2)*100}')
MEM_FREE_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($4/$2)*100}')
echo " Memory: Used ${MEM_USED_PCT}% | Free ${MEM_FREE_PCT}%"


# Disk Used
DISK_USED=$(df -h / | awk "NR==2 {print $3}")
DISK_FREE=$(df -h / | awk "NR==2 {print $4}")
DISK_PCT=$(df -h / | awk "NR==2 {print $5}")
echo " Disk (/): Used $DISK_USED | Free $DISK_FREE | ($DISK_PCT)"


# % process
echo "🔸 Top 5 Processes by CPU:"
ps aux --sort=-%cpu | head -6 | column -t
echo ""
echo "🔸 Top 5 Processes by Memory:"
ps aux --sort=-%mem | head -6 | column -t


echo "📦 OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "⏱️  Uptime: $(uptime -p)"
echo "📈 Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo "👥 Logged In: $(who | wc -l) user(s)"
echo "🚫 Recent Failed Logins:"
if command -v lastb &> /dev/null && [ -r /var/log/btmp ]; then
  lastb -f /var/log/btmp | head -3 | awk 'NR>1 {print "  "$1, "from", $3, "at", $4, $5, $6}'
else
  echo "  (Requires root or btmp log access)"
fi



echo -e "${BLUE}========================================${NC}"
echo "  📅 Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${BLUE}=========