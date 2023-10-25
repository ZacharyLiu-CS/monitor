#!/bin/bash
set -e
ulimit -n 1000000

DEPLOY_DIR=/home/kvgroup/zhenliu/monitors
# start all nodes
bash ${DEPLOY_DIR}/scripts/stop_grafana.sh
bash ${DEPLOY_DIR}/scripts/stop_prometheus.sh
bash ${DEPLOY_DIR}/scripts/stop_node_exporter.sh


