#!/bin/bash
# Alexander Pick 2022-2023
# Mail: contact@alexander-pick.com

BLUE="\e[94m"
NC="\e[0m"

NOOUT="> /dev/null 2>&1"
DATETIME=$(date -d "today" +"%Y%m%d%H%M%S")

ETH=$(ip -o -4 route show to default | awk '{print $5}')

function cleanup {
    eval "killall srsepc ${NOOUT}"
    eval "killall srsenb ${NOOUT}"
    echo 0 > /proc/sys/net/ipv4/ip_forward
}

trap cleanup EXIT

function usage {                                         
    echo -e "\nUsage: ${0##*/}\nPossible parameter:"
    echo -e "\t--help\t display this help"
}

function start_srs {

    echo -e "${BLUE}[i] starting srs stack${NC}"
    echo 1 > /proc/sys/net/ipv4/ip_forward

    /usr/local/bin/srsepc
    /usr/local/bin/srsenb

    iptables -t nat -A POSTROUTING -o ${ETH} -j MASQUERADE
    iptables -A FORWARD -i ${ETH} -o srs_spgw_sgi -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -A FORWARD -i srs_spgw_sgi -o ${ETH} -j ACCEPT


}

if [ "${1}" == "--help" ]; then
    
    usage

else 

    start_srs

fi