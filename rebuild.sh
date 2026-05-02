#!/bin/bash

# ==================================================
# rAthena Auto-Rebuilder (Optimized Edition) + Voice
# ==================================================
# Developed for: I am batman (Ubuntu 24.04)

# --- CONFIGURATION ---
PACKETVER=20250716
FOLDER_PATH="/home/iambatman/svRagnarokG"
VOICE_BIN="voice-server"
COMPILE_CORES=$(nproc)

# --- COLORS ---
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${CYAN}  rAthena Auto-Rebuilder for I am batman${NC}"
echo -e "${CYAN}  Optimized for Ubuntu 24 & LTO Performance${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"

if [ ! -d "$FOLDER_PATH" ]; then
    echo -e "${RED}❌ Error: ไม่พบโฟลเดอร์ $FOLDER_PATH${NC}"
    exit 1
fi

cd "$FOLDER_PATH" || exit

echo -e "${GREEN}[1/5] Setting file permissions...${NC}"
chmod +x configure athena-start start_turbo.sh 2>/dev/null

echo -e "${GREEN}[2/5] Stopping existing servers safely...${NC}"
./athena-start stop
sleep 3 # ให้เวลาเซิร์ฟเวอร์เซฟข้อมูลลง Database
killall -9 login-server char-server map-server "$VOICE_BIN" 2>/dev/null

echo -e "${GREEN}[3/5] Configuring for Packet Version $PACKETVER...${NC}"
if [ -f "configure" ]; then
    ./configure --enable-packetver=$PACKETVER --enable-lto \
        CFLAGS="-O3 -march=native -flto=auto -pipe" \
        CXXFLAGS="-O3 -march=native -flto=auto -pipe" \
        LDFLAGS="-flto=auto" > /dev/null
else
    echo -e "${YELLOW}⚠️ Warning: ไม่พบไฟล์ configure ข้ามขั้นตอนนี้...${NC}"
fi

echo -e "${GREEN}[4/5] Cleaning and Compiling rAthena (Threads: $COMPILE_CORES)...${NC}"
make clean > /dev/null
if ! make server -j"$COMPILE_CORES"; then
    echo -e "${RED}❌ Error: rAthena Compile Failed!${NC}"
    exit 1
fi

if [ -f "server.cpp" ]; then
    echo -e "${GREEN}[Extra] Compiling Voice Server...${NC}"
    g++ -O3 -march=native -flto server.cpp -o "$VOICE_BIN" \
        $(mysql_config --cflags --libs) -lpthread -lz -lssl -lcrypto
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error: Voice Server Compile Failed!${NC}"
    fi
fi

echo -e "${GREEN}[5/5] Finalizing...${NC}"
chmod +x login-server char-server map-server "$VOICE_BIN" 2>/dev/null

if [ -f "./start_turbo.sh" ]; then
    echo -e "${CYAN}🚀 Executing Turbo Loader...${NC}"
    exec ./start_turbo.sh
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