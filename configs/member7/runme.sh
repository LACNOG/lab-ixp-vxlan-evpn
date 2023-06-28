# create vlan91 on ether1 interface pointing to sitec-edge1 ether7
ip link add link eth1 name eth1.3232 type vlan id 3232 protocol 802.1ad
ip link add link eth1 name eth1.3232.91 type vlan id 91
ip link set eth1 up
ip link set eth1.3232 up
ip link set eth1.3232.91 up
ip address add dev eth1.3232.91 10.255.91.17/24
ip -6 address add dev eth1.3232.91 fd17:2158:6de4:cd1::17/64

