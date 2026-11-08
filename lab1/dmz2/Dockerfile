FROM ubuntu:24.04
RUN apt-get update && apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config tcpdump nmap curl ca-certificates
RUN apt-get install apache2 -y
RUN apt-get install rsyslog fail2ban -y
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN useradd -m -s /bin/bash user && echo 'user:user' | chpasswd
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# instalacion del agente de beszel (binario oficial, version fijada)
ARG BESZEL_VERSION=0.21.1
RUN curl -fsSL "https://github.com/henrygd/beszel/releases/download/v${BESZEL_VERSION}/beszel-agent_linux_amd64.tar.gz" | tar -xz -C /usr/local/bin beszel-agent \
 && chmod +x /usr/local/bin/beszel-agent

#lanzamiento de paquetes para ssl
RUN a2enmod ssl
RUN a2ensite default-ssl

#creacion de certificado propio y configuracion de https
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/dmz2.key -out /etc/ssl/certs/dmz2.crt -subj "/C=ES/O=Practica1 Sistemas Confiables/CN=10.5.1.21" -addext "subjectAltName=IP:10.5.1.21"
RUN sed -i 's|/etc/ssl/certs/ssl-cert-snakeoil.pem|/etc/ssl/certs/dmz2.crt|' /etc/apache2/sites-available/default-ssl.conf
RUN sed -i 's|/etc/ssl/private/ssl-cert-snakeoil.key|/etc/ssl/private/dmz2.key|' /etc/apache2/sites-available/default-ssl.conf
RUN apache2ctl configtest

# Hago copia de openssh default
RUN cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak-init

# Copio archivo seteado con configuraciones de ssh y valido
COPY ./config/sshd_config /etc/ssh/sshd_config
COPY ./config/banner.txt /etc/ssh/banner.txt

# Copio llave publica de int1, ajusto permisos para usar
RUN mkdir -p /home/user/.ssh
COPY ./config/authorized_keys /home/user/.ssh/authorized_keys
RUN chown -R user:user /home/user/.ssh
RUN chmod 700 /home/user/.ssh
RUN chmod 600 /home/user/.ssh/authorized_keys

RUN mkdir -p /run/sshd && sshd -t

# puertos expuestos
EXPOSE 2222 443 80

# Configuraciones para fail2ban y validaciones
COPY ./config/jail.local /etc/fail2ban/jail.local
RUN  touch /var/log/auth.log && fail2ban-client -t

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]
