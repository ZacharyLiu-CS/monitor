#!/bin/bash
set -e
ulimit -n 1000000

DEPLOY_DIR=/home/kvgroup/zhenliu/monitors
# start all nodes
bash ${DEPLOY_DIR}/scripts/run_node_exporter.sh &
bash ${DEPLOY_DIR}/scripts/run_prometheus.sh &
bash ${DEPLOY_DIR}/scripts/run_grafana.sh &



