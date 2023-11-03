#!/bin/bash
# Alexander Pick 2022-2023
# Mail: contact@alexander-pick.com

BLUE="\e[94m"
NC="\e[0m"

function usage {          
                                   
    echo -e "\nUsage: ${0##*/} <parameter1>\nPossible parameter:"
    echo -e "\t--help\t display this help"
    echo -e "\t--x40\t flash bladeRF x40"
    echo -e "\t--a4\t flash bladeRF A4"

}

function get_firmware {

        mkdir -p bladeRF_fw
        cd bladeRF_fw

        # 1.8.0 is required: 
        # https://yatebts.com/documentation/radio-access-network-documentation/yatebts-documentation/write-new-firmware-to-bladerf/

        rm /usr/src/bladeRF_fw/bladeRF_fw_v1.8.0.img
        wget https://www.nuand.com/fx3/bladeRF_fw_v1.8.0.img
        # wget https://www.nuand.com/fpga/v0.15.0/hostedx40.rbf
        # wget https://www.nuand.com/fpga/v0.15.0/hostedxA4.rbf
        cd /usr/src/

}

BRFCLI="/usr/local/bin/bladeRF-cli"

if [ -f ${BRFCLI} ]; then

    if [ "${1}" == "--help" ]; then
        
        usage

    elif [ "${1}" == "--x40" ]; then

        get_firmware

        echo -e "${BLUE}[i] updating firmware (x40)${NC}"

        ${BRFCLI} -f /usr/src/bladeRF_fw/bladeRF_fw_v1.8.0.img

        sleep 5

        echo -e "${BLUE}[i] flashing bladeRF (x40)${NC}"

        ${BRFCLI}  -L /usr/src/yate/share/data/hostedx40.rbf

    elif [ "${1}" == "--a4" ]; then

        get_firmware

        echo -e "${BLUE}[i] updating firmware ${NC}"

        ${BRFCLI} -f bladeRF_fw_v1.8.0.img

        sleep 5

        echo -e "${BLUE}[i] flashing bladeRF (x40)${NC}"

        ${BRFCLI}  -L /usr/src/yate/share/data/hostedxA4.rbf

    else 

        usage

    fi

else 
    echo -e "${RED}[e] files missing, compile the bladerf target first${NC}"
fi