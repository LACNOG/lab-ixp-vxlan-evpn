# create vlan91 on ether1 interface pointing to sitea-edge1 ether8
ip link add link eth1 name eth1.2091 type vlan id 2091
ip link set eth1 up
ip link set eth1.2091 up
ip address add dev eth1.2091 10.255.91.12/24
ip -6 address add dev eth1.2091 fd17:2158:6de4:cd1::12/64