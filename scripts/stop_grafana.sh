#!/bin/bash
set -e

ulimit -n 1000000

DEPLOY_DIR=/home/kvgroup/zhenliu/monitors

if [ -s ${DEPLOY_DIR}/proc/grafana ];
then
  sudo kill -9 $(cat ${DEPLOY_DIR}/proc/grafana)
  cat /dev/null > ${DEPLOY_DIR}/proc/grafana
  echo "Stop grafana successfully!"
else
  echo "No grafana is running!"
fi
