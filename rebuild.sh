#!/bin/bash

# ==================================================
# rAthena Auto-Rebuilder (Optimized Edition) + Voice
# ==================================================
# Developed for: Gryphon Dev (Ubuntu 24.04)

# --- CONFIGURATION ---
PACKETVER=20250716
FOLDER_PATH="/home/iambatman/svRagnarokG"
VOICE_BIN="voice-server"
COMPILE_CORES=$(nproc)

# --- COLORS ---
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${CYAN}  rAthena Auto-Rebuilder for I am batman${NC}"
echo -e "${CYAN}  Optimized for Ubuntu 24 & LTO Performance${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"

# เช็คว่ามีโฟลเดอร์อยู่จริงไหม
if [ ! -d "$FOLDER_PATH" ]; then
    echo -e "${RED}❌ Error: ไม่พบโฟลเดอร์ $FOLDER_PATH${NC}"
    exit 1
fi

cd "$FOLDER_PATH" || exit

# 1. จัดการเรื่องสิทธิ์ (Permissions)
echo -e "${GREEN}[1/5] Setting file permissions...${NC}"
chmod +x configure athena-start start_turbo.sh 2>/dev/null

# 2. ปิดเซิร์ฟเวอร์เก่าก่อน
echo -e "${GREEN}[2/5] Stopping existing server & voice-server...${NC}"
./athena-start stop
pkill -9 "$VOICE_BIN" 2>/dev/null
pkill -9 login-server char-server map-server 2>/dev/null

# 3. Configure ระบบ
echo -e "${GREEN}[3/5] Configuring for Packet Version $PACKETVER...${NC}"
# ใช้ LTO และปรับแต่ง CFLAGS สำหรับ Ubuntu 24.04
./configure --enable-packetver=$PACKETVER --enable-lto \
    CFLAGS="-O3 -march=native -flto=auto -pipe" \
    CXXFLAGS="-O3 -march=native -flto=auto -pipe" \
    LDFLAGS="-flto=auto"

# 4. คอมไพล์ rAthena
echo -e "${GREEN}[4/5] Cleaning and Compiling rAthena (Threads: $COMPILE_CORES)...${NC}"
make clean
if ! make server -j"$COMPILE_CORES"; then
    echo -e "${RED}❌ Error: rAthena Compile Failed!${NC}"
    exit 1
fi

# พิเศษ: คอมไพล์ Voice Server (กรณีเป็นไฟล์ server.cpp แยกต่างหาก)
if [ -f "server.cpp" ]; then
    echo -e "${GREEN}[Extra] Compiling Voice Server...${NC}"
    # คำสั่งคอมไพล์ Voice Server พร้อม link libmysqlclient
    g++ -O3 -march=native -flto server.cpp -o "$VOICE_BIN" \
        $(mysql_config --cflags --libs) -lpthread -lz -lssl -lcrypto
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: Voice Server Compile Failed!${NC}"
    fi
fi

# 5. ให้สิทธิ์ไฟล์และรัน
echo -e "${GREEN}[5/5] Finalizing and Starting Server...${NC}"
chmod +x login-server char-server map-server "$VOICE_BIN"

if [ -f "./start_turbo.sh" ]; then
    echo -e "${CYAN}🚀 Starting server with Turbo RAM Disk Mode...${NC}"
    ./start_turbo.sh
else
    echo -e "${CYAN}▶️ Starting server normally...${NC}"
    ./athena-start start
    if [ -f "./$VOICE_BIN" ]; then
        echo -e "${CYAN}🎙️ Starting Voice Server...${NC}"
        ./"$VOICE_BIN" > log/voice-server.log 2>&1 &
    fi
fi

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${GREEN}✅ ALL DONE! Server is Rebuilt and Running.${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"