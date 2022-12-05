#!/bin/bash
# API 2022 
# Mail: contact@alexander-pick.com

BLUE="\e[94m"
NC="\e[0m"

CAPTURES="/usr/src/captures/"

NOOUT="> /dev/null 2>&1"
DATETIME=$(date -d "today" +"%Y%m%d%H%M%S")

eval "mkdir ${CAPTURES} ${NOOUT}"

function cleanup {
  eval "killall tcpdump ${NOOUT}"
  eval "killall /usr/local/lib/yate/server/bts/mbts ${NOOUT}"
  eval "killall /usr/local/bin/yate ${NOOUT}"
}

trap cleanup EXIT

function usage {
                                                             
    echo -e "\nUsage: ${0##*/} <parameter1>\nPossible parameter:"
    echo -e "\t--help\t display this help"
    echo -e "\t--pcap\t capture a pcap of the GSM traffic via GSMtap*"
    echo -e "\t--x40\t flash bladeRF x40 before starting"
    echo -e "\t--a4\t flash bladeRF A4 before starting"
    echo -e "\t* requrires GSMTAP to be enabled (in webpanel)\n"
}

function start_yate {
    echo -e "${BLUE}[i] starting yate${NC}"
    /usr/local/bin/yate
}

if [ "${1}" == "--help" ]; then
    
    usage

elif [ "${1}" == "--pcap" ]; then
    
    echo -e "${BLUE}[i] starting tcpdump in background${NC}"
    eval "tcpdump -i any udp port 4729 -w ${CAPTURES}GSMTAP-${DATETIME}.pcap & ${NOOUT}"
    start_yate

elif [ "${1}" == "--x40" ]; then

    echo -e "${BLUE}[i] flashing bladeRF (x40)${NC}"
    bladeRF-cli -L /usr/local/share/yate/data/hostedx40.rbf

elif [ "${1}" == "--a4" ]; then

    echo -e "${BLUE}[i] flashing bladeRF (A4)${NC}"
    bladeRF-cli -L /usr/local/share/yate/data/hostedxA4.rbf

else 

    start_yate

fi