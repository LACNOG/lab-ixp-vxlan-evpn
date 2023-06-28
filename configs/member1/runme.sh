# create vlan91 on ether1 interface pointing to sitea-edge1 ether7
ip link add link eth1 name eth1.91 type vlan id 91
ip link set eth1 up
ip link set eth1.91 up
ip address add dev eth1.91 10.255.91.11/24
ip -6 address add dev eth1.91 fd17:2158:6de4:cd1::11/64