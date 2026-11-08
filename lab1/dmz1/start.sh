#!/bin/bash
route add default gw 10.5.1.1
route del default gw 10.5.1.254

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
  <h1>Practica 1 Sistemas Confiables - Este servidor está en DMZ-1</h1>
</body>
</html>
EOF



# lanzar cowrie como usuario sin privilegios (escucha en 2222)
su - cowrie -c 'cd ~/cowrie && source cowrie-env/bin/activate && cowrie start'


# lanzar agente de beszel: conecta por websocket al hub (HUB_URL), sin servidor ssh propio
if [ -n "$KEY" ] && [ -n "$TOKEN" ]; then
  beszel-agent > /var/log/beszel-agent.log 2>&1 &
else
  echo "beszel-agent no lanzado: faltan KEY y/o TOKEN (ver lab1/.env)"
fi

/usr/sbin/sshd -D