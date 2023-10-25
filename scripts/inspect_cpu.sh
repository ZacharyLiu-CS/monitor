#!/bin/bash

# Usage: sudo inspect_cpu.sh pid
DEPLOY_DIR=/home/kvgroup/zhenliu/monitors

perf record -F 400 -p $1 -g -- sleep 60
perf script |${DEPLOY_DIR}/opt/FlameGraph/stackcollapse-perf.pl | ${DEPLOY_DIR}/opt/FlameGraph/flamegraph.pl >${DEPLOY_DIR}/data/cpu.svg
