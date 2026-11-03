FROM ubuntu:24.04
RUN apt-get update && apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config tcpdump nmap curl
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22

# Copia lave privada para conectarse a dmz2 
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
COPY ./ssh/id_ed25519 /root/.ssh/id_ed25519
RUN chmod 600 /root/.ssh/id_ed25519

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]