FROM ubuntu:24.04
RUN apt-get update && apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config tcpdump nmap
RUN apt-get install apache2 -y
RUN apt-get install rsyslog fail2ban -y
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN useradd -m -s /bin/bash user && echo 'user:user' | chpasswd
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# Cambio a puerto 2222 para ssh
EXPOSE 2222

# Configuraciones para fail2ban y validaciones
COPY ./config/jail.local /etc/fail2ban/jail.local
RUN  touch /var/log/auth.log && fail2ban-client -t

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]