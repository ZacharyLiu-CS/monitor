#!/bin/bash
set -e
ulimit -n 1000000

# WARNING: This file was auto-generated. Do not edit!
#          All your edit might be overwritten!
DEPLOY_DIR=/home/kvgroup/zhenliu/monitors
cd "${DEPLOY_DIR}" || exit 1
echo $$ > ${DEPLOY_DIR}/proc/grafana
LANG=en_US.UTF-8 \
exec ${DEPLOY_DIR}/opt/grafana/bin/grafana-server \
        --homepath="${DEPLOY_DIR}/opt/grafana" \
        --config="${DEPLOY_DIR}/conf/grafana.ini"




