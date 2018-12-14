v=0.14.0

version=v$v
file=alertmanager-$v.linux-amd64
service=alertmanager

wget https://github.com/prometheus/alertmanager/releases/download/$version/$file.tar.gz \
  -O /tmp/$file.tar.gz

systemctl is-enabled $service
if [ $? -eq 0 ]; then
  systemctl stop $service
fi


cd /tmp
tar xvf /tmp/$file.tar.gz

cp /tmp/$file/alertmanager /usr/local/bin/alertmanager
cp /tmp/$file/amtool /usr/bin/amtool

tee /usr/lib/systemd/system/${service}.service << EOS
[Unit]
Description=alertmanager

[Service]
Restart=always
ExecStart=/usr/local/bin/alertmanager --config.file /etc/prometheus/alertmanager.yml

[Install]
WantedBy=default.target
EOS


systemctl daemon-reload
systemctl enable $service
systemctl start $service

cd -


