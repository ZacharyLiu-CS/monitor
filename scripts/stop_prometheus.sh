#!/bin/bash
set -e

ulimit -n 1000000

DEPLOY_DIR=/home/kvgroup/zhenliu/monitors

if [ -s ${DEPLOY_DIR}/proc/prometheus ];
then
  sudo kill -9 $(cat ${DEPLOY_DIR}/proc/prometheus)
  cat /dev/null > ${DEPLOY_DIR}/proc/prometheus
  echo "Stop prometheus successfully!"
else
  echo "No prometheus is running!"
fi
