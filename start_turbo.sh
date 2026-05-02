#!/bin/bash

# ==================================================
# rAthena Turbo Loader (RAM Disk Edition) + Voice
# ==================================================
# Optimized for: I am batman

# --- CONFIGURATION ---
SRC_DIR="/home/iambatman/svRagnarokG"
RAM_DIR="/dev/shm/rathena_turbo"
VOICE_BIN="voice-server"

# --- COLORS ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${CYAN}  Starting rAthena Turbo Loader (RAM Disk)${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"

echo -e "${GREEN}[1/4] Stopping servers safely...${NC}"
cd "$SRC_DIR" || exit
./athena-start stop
sleep 3 # รอคืน RAM และเซฟ SQL
killall -9 login-server char-server map-server "$VOICE_BIN" 2>/dev/null

echo -e "${GREEN}[2/4] Preparing RAM Disk ($RAM_DIR)...${NC}"
mkdir -p "$RAM_DIR"

echo -e "${GREEN}[3/4] Syncing files to RAM (Fast I/O)...${NC}"
rsync -a --delete \
    --exclude='.git*' \
    --exclude='src' \
    --exclude='sql-files' \
    --exclude='*.cpp' \
    --exclude='*.hpp' \
    --exclude='*.c' \
    --exclude='*.h' \
    --exclude='*.o' \
    --exclude='obj' \
    --exclude='*.a' \
    --exclude='log' \
    "$SRC_DIR/" "$RAM_DIR/"

# SAFETY FIX: ลิงก์โฟลเดอร์ log จาก HDD จริงมาที่ RAM เพื่อไม่ให้ log หายเมื่อไฟดับ
ln -s "$SRC_DIR/log" "$RAM_DIR/log"

# === พื้นที่สำหรับจัดเรียงสคริปต์ A-Z และหมวดหมู่ ===
# ถ้าระบบเรียงสคริปต์ของคุณอยู่ในโฟลเดอร์ npc สามารถสั่งรันได้ตรงนี้ครับ
# ===============================================

echo -e "${GREEN}[4/4] Launching Server & Voice from RAM...${NC}"
cd "$RAM_DIR" || exit
chmod +x login-server char-server map-server "$VOICE_BIN" athena-start 2>/dev/null

./athena-start start

if [ -f "./$VOICE_BIN" ]; then
    echo -e "${CYAN}🎙️ Starting Voice Server in background...${NC}"
    nohup ./"$VOICE_BIN" > "$SRC_DIR/log/voice-server.log" 2>&1 &
    echo -e "${YELLOW}💡 Voice Log: $SRC_DIR/log/voice-server.log${NC}"
else
    echo -e "${YELLOW}⚠️ Warning: $VOICE_BIN not found, skipping voice start.${NC}"
fi

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${GREEN}✅ Turbo Loader Active!${NC}"
echo -e "${CYAN}  เซิร์ฟเวอร์รันบน RAM (/dev/shm) ปลอดภัยและรวดเร็ว${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"