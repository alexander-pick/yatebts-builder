#!/bin/bash
# requires bladerf

ip netns add ue1
echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
srsue configs/ue_5g.conf
