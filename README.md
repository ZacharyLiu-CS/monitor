# Monitor Project targets

Help to quickly start a monitor service with promethus and grafana.
1. Some usefull scripts to help start or shutdown the promethus and the grafana process.
2. Well structured project with config directory, binary files and data storage.
3. Learn from the /proc mechanism in linux, use the proc file to indicate the liveness of process.

# Directory Usage
```
.
├── bin
│   ├── node_exporter   // node_exporter 可执行文件
│   └── prometheus      //  prometheus 可执行文件
├── conf
│   ├── grafana.ini     // grafana 配置文件
│   └── prometheus.yml  // prometheus 配置文件
├── data                // 存储 prometheus 以及 grafana 数据
├── downloads
│   └── download_files  // 下载目录，用于后续更新，解压后覆盖对应可执行文件目录
├── log                 // 存储日志文件
├── opt                 // 存储日志文件
│   ├── FlameGraph      // 用于火焰图等性能观测常用工具
│   └── grafana         // grafana 项目目录 
├── proc
│   ├── grafana         // 启动后记录 grafana 进程 id
│   ├── node_exporter   // 启动后记录 node_exporter 进程 id
│   └── prometheus      // 启动后记录 prometheus 进程 id
├── README.md
└── scripts
    ├── inspect_cpu.sh    // 使用 perf 统计进程执行函数栈调用时间信息，并用绘制成火焰图
    ├── run_grafana.sh    // 启动 grafana
    ├── run_node_exporter.sh  // 启动 node_exporter
    ├── run_prometheus.sh     // 启动 prometheus
    ├── start_all.sh          // 按次序依次执行对应启动脚本
    ├── stop_all.sh           // 按次序依次执行对应停止脚本
    ├── stop_grafana.sh       // 停止 grafana
    ├── stop_node_exporter.sh // 停止 node_exporter
    └── stop_prometheus.sh    // 停止 prometheus
```
# Config Customization
1. 脚本执行目录配置
修改所有 scripts/ 目录下的 shell 脚本，将其中的 `DEPLOY_DIR` 变量修改为本 monitor 的目录，可通过一下命令统一修改：
```
sed -i "s|DEPLOY_DIR=.*|DEPLOY_DIR=$(pwd)|" scripts/*
```
2. prometheus 配置
普罗米修斯配置非常简单，他分为配置监听目标以及配置自身 web 管理端口两部分。
- 第一步配置 conf/prometheus.yml 文件中的 scrape_configs, 根据 tkv 中配置的对应 prometheus 端口号以及实际 ip 修改以下模板
```
  - job_name: "tkv"
    honor_labels: true # don't overwrite job & instance labels
    static_configs:
    - targets:
      - '192.168.1.102:9180'
```
- 第二步配置 scripts/run_prometheus.sh 中的 prometheus web UI ip 以及端口配置
将其中 ip 以及端口改为自定义配置
```
    --web.listen-address=":9601" \
    --web.external-url="http://192.168.1.116:9601/" \
```
完成上述步骤可以执行 run_prometheus.sh 启动 proemtheus，并通过对应端口号访问服务，其中访问对应 /targets url 可以查看所有监听目标状态是否正常


3. grafana 配置
- 第一步：修改 `[path]` 条目下数据以及日志存储目录变量: `data`, `logs`, `plugins`， 一键修改命令:
```
sed -i "s|/home/kvgroup/zhenliu/monitors|$(pwd)|g" conf/grafana.ini
```
- 第二部：修改 grafana web UI ip 以及端口号
```
http_port = 9602
domain = 192.168.1.116
```
- 第三步：修改 grafana 管理员账号以及密码
```
admin_user = zach

admin_password = 1
```
完成上述配置可以执行 run_grafana.sh 启动 grafana，通过对应端口号，输入账号密码访问服务，包括添加 prometheus 数据源，导入 panel 的 json 文件定制监听
面板。


4. node_exporter [可选项]
node_exporter 是一个轻量级的监听进程，它能够实时检测宿主机的 memory，cpu，disk io 等系统信息，然后被 prometheus 抓取并存储到数据库中，然后通过 grafana 显示出来。
- 第一步：配置 node_exporter 启动参数
修改 scripts/run_node_exporter.sh 文件中对应端口号(可按照默认不动)
```
exec ${DEPLOY_DIR}/bin/node_exporter --web.listen-address=":9600" \
```
- 第二步: 配置 prometheus 对应监听目标
修改 conf/prometheus.yml, 添加对应配置如下, ip 改为实际 ip，端口号和上述保持一致。
```
  - job_name: "node_exporter"
    honor_labels: true # don't overwrite job & instance labels/
    static_configs:
    - targets:
      - '192.168.1.102:9600'
```
完成上述步骤，可以启动 scirpts/run_node_exporter 验证。如果成功启动，可以访问 node_exporter 对应监听端口，查看所有监听指标，然后可以访问 prometheus 对
应的 `/targets` url, 查看是否处于活跃状态 (注意 prometheus 需要重启，修改的新配置才能生效)。

5. `start_all.sh`/`stop_all.sh` 脚本修改
这两个脚本用于一键启动或关闭监控进程，启动与关闭项目顺序相反，可以酌情考虑配置。如 node_exporter, 与 prometheus 不在一台机器，那么可以将
`run_node_exporter` 与 `stop_node_exporter` 从其中删除。


