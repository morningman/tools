#!/bin/bash

# show the network download and upload speed

while true; do
  RX1=$(cat /proc/net/dev | grep eth0 | awk '{print $2}')
  TX1=$(cat /proc/net/dev | grep eth0 | awk '{print $10}')
  sleep 1
  RX2=$(cat /proc/net/dev | grep eth0 | awk '{print $2}')
  TX2=$(cat /proc/net/dev | grep eth0 | awk '{print $10}')
  RX_RATE=$((($RX2 - $RX1)/1024))
  TX_RATE=$((($TX2 - $TX1)/1024))
  echo "Download: ${RX_RATE} KB/s | Upload: ${TX_RATE} KB/s"
done
