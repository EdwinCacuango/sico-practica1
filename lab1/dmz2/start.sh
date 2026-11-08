#!/bin/bash
route add default gw 10.5.1.1
route del default gw 10.5.1.254


# File para almacenar servicios, cambio de permisos y lanzamiento de rsyslog con su demonio
chown syslog:adm /var/log/auth.log
chmod 640 /var/log/auth.log
rsyslogd

# Lanzar fail2ban
fail2ban-server -xb start


#lanzar apache
service apache2 start

tee /var/www/html/index.html > /dev/null <<"EOF"
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Practica 1 Sistemas Confiables</title>
</head>
<body>
  <h1>Practica 1 Sistemas Confiables - Este servidor está en DMZ-2</h1>
</body>
</html>
EOF


# lanzar agente de beszel: conecta por websocket al hub (HUB_URL), sin servidor ssh propio
if [ -n "$KEY" ] && [ -n "$TOKEN" ]; then
  beszel-agent > /var/log/beszel-agent.log 2>&1 &
else
  echo "beszel-agent no lanzado: faltan KEY y/o TOKEN (ver lab1/.env)"
fi

/usr/sbin/sshd -D