#!/bin/bash


while true; do

 target=$(netstat -tapn |awk '{print $5}' |grep -E ^[0-9] |cut -d: -f1|sort|uniq -c|sed -r 's/^[[:space:]]+//g' |sort -k1 -n -r |head -1)


 number_of_connections=$(echo "$target" | awk  '{print $1}')
 ip_target=$(echo "$target" | awk  '{print $2}')


echo "Nmero de conexiones: $number_of_connections"
echo "IP target: $ip_target"



if [ $number_of_connections  -gt 99 ]; then
    echo "Bloquear IP"
    if iptables -C INPUT -s $ip_target -j DROP  2>/dev/null; then
	echo "La regla ya existe"
    else
	iptables -A INPUT -s $ip_target -j DROP
	echo "IP bloqueada $ip_target"
    fi
else
    echo "Todo bien"
fi

   sleep 15
done
