#!/bin/bash

#FASE 1
#estas son las reglas generales/default
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

#con esto permito el trafico por loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#permitir ping con limitaciones por minuto y por numero de intentos
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/minute -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

#aceptar inputs de comunicaciones ya establecidas y relacionadas. Esta al final para que no se pise en pruebas t3
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT



##configuraciones para gestion de trafico desde intranet
#esto permite sacar cosas ya establecidas desde las interfaces conectadas a fw
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#Esto para permitir que todo el trafico nuevo desde intranet pueda salir, a donde sea. incluyendo mi propia subred
iptables -A FORWARD -s 10.5.2.0/24 -p tcp  -j ACCEPT
iptables -A FORWARD -s 10.5.2.0/24 -p udp -j ACCEPT
iptables -A FORWARD -s 10.5.2.0/24 -p icmp -j ACCEPT

/usr/sbin/sshd -D