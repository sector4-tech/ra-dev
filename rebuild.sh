#!/bin/bash

# กำหนดสีเพื่อให้ดู Log ง่ายขึ้น
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}--- Starting Cleanup ---${NC}"
make clean

echo -e "${GREEN}--- Generating Makefile ---${NC}"
# รวม Flag ทั้งหมดไว้ในการรันครั้งเดียว
./configure --with-mysql_config=/usr/bin/mariadb_config --enable-epoll=yes --enable-packetver=20260107

echo -e "${GREEN}--- Building Server ---${NC}"
# ใช้ -j$(nproc) เพื่อคอมไพล์แบบขนาน
make server -j$(nproc)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}--- Build Finished Successfully! ---${NC}"
else
    echo "--- Build Failed! Please check the error logs above. ---"
    exit 1
fi
