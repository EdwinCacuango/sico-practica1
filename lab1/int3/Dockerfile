FROM ubuntu:24.04
RUN apt-get update && apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config tcpdump nmap curl ca-certificates
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# instalacion de beszel
ARG BESZEL_VERSION=0.21.1
#version fijada como param
RUN mkdir -p /opt/beszel 
RUN curl -fsSL "https://github.com/henrygd/beszel/releases/download/v${BESZEL_VERSION}/beszel_linux_amd64.tar.gz" | tar -xz -C /opt/beszel beszel
RUN chmod +x /opt/beszel/beszel

EXPOSE 22 8090
COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]