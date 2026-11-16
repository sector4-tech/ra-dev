#!/bin/bash

# ==================================================
# rAthena Watchdog (Auto-Restart Monitor) + Voice
# ==================================================
# สคริปต์นี้จะทำงานทุกๆ 1 นาที (ผ่าน Crontab)

SRC_DIR="/home/iambatman/svRagnarokG"
LOG_FILE="$SRC_DIR/log/watchdog.log"
VOICE_BIN="voice-server"

cd "$SRC_DIR" || exit

# --- ระบบความปลอดภัย: โหมดปิดปรับปรุง ---
if [ -f "manual_stop.txt" ]; then
    exit 0
fi

# ตรวจสอบสถานะของโปรเซสหลักทั้งหมด (รวม Voice Server)
LOGIN_RUNNING=$(pgrep -x "login-server")
CHAR_RUNNING=$(pgrep -x "char-server")
MAP_RUNNING=$(pgrep -x "map-server")
VOICE_RUNNING=$(pgrep -x "$VOICE_BIN")

# ถ้าระบบใดระบบหนึ่งดับไป (Crash) ให้ทำการ Restart ทันที
if [ -z "$LOGIN_RUNNING" ] || [ -z "$CHAR_RUNNING" ] || [ -z "$MAP_RUNNING" ] || [ -z "$VOICE_RUNNING" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️ Alert: Server component or Voice Server crashed! Executing Auto-Restart..." >> "$LOG_FILE"
    
    # เรียกใช้ Turbo Loader เพื่อคลีนและสตาร์ทใหม่ (ใน Turbo Loader มีสั่งเปิด Voice อยู่แล้ว)
    ./start_turbo.sh >> "$LOG_FILE" 2>&1
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Recovery: Server successfully restarted." >> "$LOG_FILE"
fi