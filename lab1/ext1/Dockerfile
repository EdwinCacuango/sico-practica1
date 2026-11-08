FROM ubuntu:24.04
RUN apt-get update && apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config tcpdump nmap hping3
RUN apt-get install apache2 -y
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#lanzamiento de paquetes para ssl
RUN a2enmod ssl
RUN a2ensite default-ssl

#creacion de certificado propio y configuracion de https
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ext1.key -out /etc/ssl/certs/ext1.crt -subj "/C=ES/O=Practica1 Sistemas Confiables/CN=10.5.0.20" -addext "subjectAltName=IP:10.5.0.20"
RUN sed -i 's|/etc/ssl/certs/ssl-cert-snakeoil.pem|/etc/ssl/certs/ext1.crt|' /etc/apache2/sites-available/default-ssl.conf
RUN sed -i 's|/etc/ssl/private/ssl-cert-snakeoil.key|/etc/ssl/private/ext1.key|' /etc/apache2/sites-available/default-ssl.conf
RUN apache2ctl configtest

EXPOSE 22 443 80
COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]
