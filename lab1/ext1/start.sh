#!/bin/bash
route add default gw 10.5.0.1
route del default gw 10.5.0.254

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
  <h1>Practica 1 Sistemas Confiables - Este servidor está en Extranet</h1>
</body>
</html>
EOF

#lanzar bash
/usr/sbin/sshd -D