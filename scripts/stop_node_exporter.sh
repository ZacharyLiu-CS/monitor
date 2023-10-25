#!/bin/bash
set -e

ulimit -n 1000000

DEPLOY_DIR=/home/kvgroup/zhenliu/monitors

if [ -s ${DEPLOY_DIR}/proc/node_exporter ];
then
  sudo kill -9 $(cat ${DEPLOY_DIR}/proc/node_exporter)
  cat /dev/null > ${DEPLOY_DIR}/proc/node_exporter
  echo "Stop node_exporter successfully!"
else
  echo "No node_exporter is running!"
fi
