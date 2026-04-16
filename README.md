# 📊 Server Stats Script: Flow Diagram & Interactive Build Guide

## 🔹 Step 1: Flow Diagram
Here’s the logical flow of the script. We'll build it top-to-bottom, testing each piece interactively.

```
┌─────────────────────┐
│       START         │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  Initialize Header  │
│ (Shebang, Colors,   │
│  Output Formatting) │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  Stretch: System Info│
│ OS, Uptime, Load Avg│
│ Logged Users        │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│     CPU USAGE       │
│ (Parse idle % from  │
│  top/vmstat/proc)   │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│    MEMORY USAGE     │
│ (free → Used/Free   │
│  & Percentages)     │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│     DISK USAGE      │
│ (df / → Used/Free   │
│  & Percentage)      │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ TOP 5 PROCESSES     │
│ (ps → Sort by CPU   │
│  then by MEM)       │
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  Stretch: Security  │
│ Failed Logins (root)│
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│  FORMAT & DISPLAY   │
│ (Align, Color, Exit)│
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│        END          │
└─────────────────────┘
```

---

## 🛠️ Interactive Step-by-Step Build Guide

Open your terminal. We'll build this **piece by piece**. Run each command, observe the output, then I'll show you how to script it.

### 🔹 Phase 1: Setup & Structure
**Try this in your terminal:**
```bash
touch server-stats.sh
chmod +x server-stats.sh
nano server-stats.sh  # or use vim/code editor
```
Add the shebang and a simple header:
```bash
#!/bin/bash
# server-stats.sh - Basic Linux Performance Monitor
echo "=== Server Performance Report ==="
```
✅ *Save & run:* `./server-stats.sh` → Should print the header.

---

### 🔹 Phase 2: CPU Usage
Linux doesn't have a single "CPU usage" file. We calculate it from **idle %**.
**Try this:**
```bash
top -bn1 | grep "Cpu(s)"
```
You'll see something like: `%Cpu(s):  2.1 us,  0.0 sy,  0.0 ni, 97.9 id, ...`
We want the number before `id` (idle), then do `100 - idle`.

**Script it:**
```bash
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
CPU_USED=$(awk "BEGIN {printf \"%.1f%%\", 100-$CPU_IDLE}")
echo "🔹 CPU Usage: $CPU_USED"
```
✅ Add to your script, run it. You should see `CPU Usage: XX.X%`.

---

### 🔹 Phase 3: Memory Usage
**Try this:**
```bash
free -m | grep Mem
```
Output: `Mem:        7982        1234        5678         123         987        6234`
Columns: `$2=Total`, `$3=Used`, `$4=Free`

**Script it:**
```bash
MEM_USED_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($3/$2)*100}')
MEM_FREE_PCT=$(free -m | awk '/^Mem:/ {printf "%.1f", ($4/$2)*100}')
echo "🔹 Memory: Used ${MEM_USED_PCT}% | Free ${MEM_FREE_PCT}%"
```
✅ Add & run. Works consistently across modern Linux distros.

---

### 🔹 Phase 4: Disk Usage
**Try this:**
```bash
df -h /
```
Second line has: `Filesystem Size Used Avail Use% Mounted`
We want `$3` (Used), `$4` (Free/Avail), `$5` (Percentage)

**Script it:**
```bash
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_PCT=$(df -h / | awk 'NR==2 {print $5}')
echo "🔹 Disk (/): Used $DISK_USED | Free $DISK_FREE ($DISK_PCT)"
```
✅ Add & run.

---

### 🔹 Phase 5: Top 5 Processes
**Try this:**
```bash
ps aux --sort=-%cpu | head -6
ps aux --sort=-%mem | head -6
```
`--sort=-%cpu` sorts descending. `head -6` shows header + 5 processes.

**Script it:**
```bash
echo "🔸 Top 5 Processes by CPU:"
ps aux --sort=-%cpu | head -6 | column -t
echo ""
echo "🔸 Top 5 Processes by Memory:"
ps aux --sort=-%mem | head -6 | column -t
```
✅ `column -t` auto-aligns columns beautifully.

---

### 🔹 Phase 6: Stretch Goals
Let's add OS, Uptime, Load Avg, Logged Users, and Failed Logins.

**Run these individually to see outputs:**
```bash
cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2
uptime -p
uptime | awk -F'load average:' '{print $2}'
who
```
**Failed logins** require root (reads `/var/log/btmp`):
```bash
sudo lastb -f /var/log/btmp | head -5
```

**Script it (with permission check for lastb):**
```bash
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
```

---

## 📜 Final `server-stats.sh` Script
Combine everything into a clean, production-ready script:

```bash
#!/bin/bash
# server-stats.sh - Basic Linux Server Performance Monitor
# Usage: ./server-stats.sh

# ANSI Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo "       🖥️  SERVER PERFORMANCE REPORT       "
echo "========================================${NC}"

# 📦 Stretch: System Info
OS_VER=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Unknown")
UPTIME=$(uptime -p)
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
USERS=$(who | wc -l)

echo -e "${GREEN}[SYSTEM INFO]${NC}"
echo "  OS          : $OS_VER"
echo "  Uptime      : $UPTIME"
echo "  Load Average: $LOAD_AVG"
echo "  Logged Users: $USERS"
echo ""

# 🔹 CPU Usage
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/')
CPU_USED=$(awk "BEGIN {printf \"%.1f%%\", 100-${CPU_IDLE:-0}}")
echo -e "${GREEN}[CPU]${NC}"
echo "  Total Usage : ${CPU_USED}"
echo ""

# 🔹 Memory Usage
MEM_STATS=$(free -m | awk '/^Mem:/ {printf "Used: %.1f%% (%.0fMB) | Free: %.1f%% (%.0fMB)", ($3/$2)*100, $3, ($4/$2)*100, $4}')
echo -e "${GREEN}[MEMORY]${NC}"
echo "  $MEM_STATS"
echo ""

# 🔹 Disk Usage
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_PCT=$(df -h / | awk 'NR==2 {print $5}')
echo -e "${GREEN}[DISK (/)]${NC}"
echo "  Used: $DISK_USED | Free: $DISK_FREE ($DISK_PCT)"
echo ""

# 🔸 Top 5 Processes by CPU
echo -e "${YELLOW}[TOP 5 PROCESSES BY CPU]${NC}"
ps aux --sort=-%cpu | head -6 | column -t
echo ""

# 🔸 Top 5 Processes by Memory
echo -e "${YELLOW}[TOP 5 PROCESSES BY MEMORY]${NC}"
ps aux --sort=-%mem | head -6 | column -t
echo ""

# 🚫 Stretch: Failed Logins
echo -e "${RED}[RECENT FAILED LOGINS]${NC}"
if command -v lastb &> /dev/null && [ -r /var/log/btmp ]; then
  lastb -f /var/log/btmp 2>/dev/null | awk 'NR>1 && NR<=4 {printf "  %-10s from %-15s at %s %s %s %s\n", $1, $3, $4, $5, $6, $7}'
else
  echo "  (Requires root privileges to read /var/log/btmp)"
fi

echo -e "${BLUE}========================================${NC}"
echo "  📅 Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${BLUE}========================================${NC}"
```

---

## 🚀 How to Run & Test
1. Save the script as `server-stats.sh`
2. Make it executable: `chmod +x server-stats.sh`
3. Run it: `./server-stats.sh`
4. For failed logins: `sudo ./server-stats.sh`

### 💡 Pro Tips for Customization
- **Change disk path**: Replace `/` in `df -h /` with `/home`, `/var`, etc.
- **Add alerts**: Use `if [ "${CPU_USED%\%*}" -gt 90 ]; then echo "⚠️ CPU CRITICAL!"; fi`
- **Cron automation**: Add `0 * * * * /path/to/server-stats.sh >> /var/log/server-stats.log` to crontab.

---

## 🧠 How the Key Commands Work (Quick Reference)
| Command | Purpose |
|--------|---------|
| `top -bn1` | Non-interactive `top`, runs once (`b`atch mode, `n`=1 iteration) |
| `sed 's/.*, *\([0-9.]*\)%* id.*/\1/'` | Extracts idle CPU % using regex |
| `free -m \| awk '/^Mem:/ {...}'` | Parses memory, `$2`=total, `$3`=used, `$4`=free |
| `df -h / \| awk 'NR==2 {...}'` | Skips header (`NR==2`), grabs disk columns |
| `ps aux --sort=-%cpu` | Lists all processes, sorts descending by CPU |
| `column -t` | Auto-aligns tabular output into neat columns |

---

## ✅ Next Steps (Interactive Challenge)
1. Run the script on your server/VM.
2. Try modifying the `df` line to show `/home` usage instead of `/`.
3. Add a simple `if` condition to print `⚠️ HIGH CPU` if usage > 85%.
4. Reply with your modified snippet or any errors you hit, and I’ll help you debug & optimize it!

Ready to run it? Let me know how it behaves on your system. 🛠️