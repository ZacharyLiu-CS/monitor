#!/bin/bash
set -e
ulimit -n 1000000

DEPLOY_DIR=/home/kvgroup/zhenliu/monitors
cd "${DEPLOY_DIR}" || exit 1

# WARNING: This file was auto-generated. Do not edit!
#          All your edit might be overwritten!
exec > >(tee -i -a "${DEPLOY_DIR}/log/prometheus.log")
exec 2>&1
echo $$ > ${DEPLOY_DIR}/proc/prometheus
exec ${DEPLOY_DIR}/bin/prometheus \
    --config.file="${DEPLOY_DIR}/conf/prometheus.yml" \
    --web.listen-address=":9601" \
    --web.external-url="http://192.168.1.116:9601/" \
    --web.enable-admin-api \
    --log.level="info" \
    --storage.tsdb.path="${DEPLOY_DIR}/data/prometheus_data/prometheus2.0.0.data.metrics" \
    --storage.tsdb.retention="30d"
