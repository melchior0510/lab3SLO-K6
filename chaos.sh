#!/usr/bin/env bash
# Алхам 5-ын гар ажиллагааг (Ctrl+C -> 10с -> дахин асаах) автоматжуулсан туслах скрипт.
# Ажиллуулах: bash chaos.sh   (k6, node суусан, lab03/ хавтаст)
set -u
mkdir -p results
node server.js > /dev/null 2>&1 & SRV=$!
sleep 1
k6 run --duration 2m slo-test.js > results/chaos.txt 2>&1 & K6=$!
sleep 40
echo "server killed   : $(date +%T)"; kill $SRV; wait $SRV 2>/dev/null
sleep 10
echo "server restarted: $(date +%T)"
node server.js > /dev/null 2>&1 & SRV=$!
wait $K6; echo "k6 exit code    : $?"
kill $SRV
