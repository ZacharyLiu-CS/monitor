#!/bin/bash
set -e
ulimit -n 1000000

# WARNING: This file was auto-generated. Do not edit!
#          All your edit might be overwritten!
DEPLOY_DIR=/home/kvgroup/zhenliu/monitors
cd "${DEPLOY_DIR}" || exit 1

exec > >(tee -i -a "${DEPLOY_DIR}/log/node_exporter.log")
exec 2>&1
echo $$ > ${DEPLOY_DIR}/proc/node_exporter
exec ${DEPLOY_DIR}/bin/node_exporter --web.listen-address=":9600" \
    --collector.tcpstat \
    --collector.systemd \
    --collector.mountstats \
    --collector.meminfo_numa \
    --collector.interrupts \
    --collector.vmstat.fields="^.*" \
    --log.level="info"
