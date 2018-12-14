version=v0.14.0

uname -m | grep v7
if [ $? -eq 0 ]; then
  file=node_exporter-0.14.0.linux-armv7
else
  file=node_exporter-0.14.0.linux-armv6
fi



wget https://github.com/prometheus/node_exporter/releases/download/$version/$file.tar.gz \
  -O /tmp/$file.tar.gz

cd /tmp
tar xvf /tmp/$file.tar.gz

cp /tmp/$file/node_exporter /usr/local/bin/node_exporter


tee /usr/lib/systemd/system/node_exporter.service << EOS
[Unit]
Description=Node Exporter

[Service]
ExecStart=/usr/local/bin/node_exporter  --collector.textfile.directory="/tmp/node_exporter"


[Install]
WantedBy=default.target
EOS


systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

cd -

