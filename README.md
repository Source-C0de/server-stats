# server-stats
Server Performance Stats


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