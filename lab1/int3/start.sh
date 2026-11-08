#!/bin/bash
route add default gw 10.5.2.1
route del default gw 10.5.2.254

# lanzar hub de beszel (datos persistentes en el volumen beszel_data)
cd /opt/beszel && ./beszel serve --http "0.0.0.0:8090" --dir /opt/beszel/beszel_data > /var/log/beszel.log 2>&1 &
cd /

/usr/sbin/sshd -D