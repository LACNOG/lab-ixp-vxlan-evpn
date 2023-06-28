ifconfig eth0 0 down
ip address add dev eth1 100.64.0.130/24
ip -6 address add dev eth1 2001:db8::130/64
ip link set eth1 up
ip route add default via 100.64.0.1
