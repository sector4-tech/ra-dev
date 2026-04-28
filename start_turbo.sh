#!/bin/bash

# ==================================================
# rAthena Turbo Loader (RAM Disk Edition) + Voice
# ==================================================
# Optimized for: iambatman / Gryphon Dev

# --- CONFIGURATION ---
SRC_DIR="/home/iambatman/svRagnarokG"
RAM_DIR="/dev/shm/rathena_turbo"
VOICE_BIN="voice-server"

# --- COLORS ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${CYAN}  Starting rAthena Turbo Loader (RAM Disk)${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"

# 1. หยุดเซิร์ฟเวอร์เก่า
echo -e "${GREEN}[1/4] Cleaning up existing processes...${NC}"
cd "$SRC_DIR" || exit
./athena-start stop
pkill -9 "$VOICE_BIN" 2>/dev/null
pkill -9 login-server char-server map-server 2>/dev/null

# 2. เตรียม RAM Disk
echo -e "${GREEN}[2/4] Preparing RAM Disk ($RAM_DIR)...${NC}"
mkdir -p "$RAM_DIR"
# สร้างโฟลเดอร์ log รอไว้เลยเพื่อให้รันได้ทันทีโดยไม่มี Error
mkdir -p "$RAM_DIR/log"

# 3. ซิงค์ไฟล์ (rsync)
echo -e "${GREEN}[3/4] Syncing files to RAM (Fast I/O)...${NC}"
# คัดเลือกเฉพาะไฟล์ที่จำเป็นต่อการรัน เพื่อประหยัดพื้นที่ RAM ให้มากที่สุด
rsync -a --delete \
    --exclude='.git' \
    --exclude='src' \
    --exclude='*.cpp' \
    --exclude='*.hpp' \
    --exclude='*.c' \
    --exclude='*.h' \
    --exclude='*.o' \
    --exclude='obj' \
    --exclude='*.a' \
    "$SRC_DIR/" "$RAM_DIR/"

# 4. รันเซิร์ฟเวอร์จาก RAM
echo -e "${GREEN}[4/4] Launching Server & Voice from RAM...${NC}"
cd "$RAM_DIR" || exit
chmod +x login-server char-server map-server "$VOICE_BIN" athena-start

# เริ่ม rAthena
./athena-start start

# เริ่ม Voice Server
if [ -f "./$VOICE_BIN" ]; then
    echo -e "${CYAN}🎙️ Starting Voice Server in background...${NC}"
    # รัน Voice Server ด้วย nohup และเก็บ Log ไว้ใน RAM Disk
    nohup ./"$VOICE_BIN" > log/voice-server.log 2>&1 &
    echo -e "${YELLOW}💡 Voice Log: $RAM_DIR/log/voice-server.log${NC}"
else
    echo -e "${YELLOW}⚠️ Warning: $VOICE_BIN not found, skipping voice start.${NC}"
fi

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${GREEN}✅ Turbo Loader Active!${NC}"
echo -e "${CYAN}  เซิร์ฟเวอร์รันบน RAM (/dev/shm) เพื่อความเร็วสูงสุด${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"