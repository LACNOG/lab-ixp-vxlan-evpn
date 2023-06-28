# Create bridge and VTEP with VNI 32
ip link add name bridge32 type bridge
ip link set eth5 master bridge32 # connection to PC1 eth1
ip link add vni32 type vxlan local 10.32.0.9 dstport 4789 id 32 nolearning
ip link set vni32 master bridge32 addrgenmode none
ip link set vni32 type bridge_slave neigh_suppress on learning off
ip link set vni32 up
ip link set bridge32 up

# Create IPFRF CDN1 / L3VNI 91
ip link add vrfCDN1 type vrf table 1091
ip link set vrfCDN1 up
ip link add brCDN1 type bridge
ip link set brCDN1 master vrfCDN1 addrgenmode none
ip link set brCDN1 addr aa:bb:cc:00:00:91
ip link add vni91 type vxlan id 91 local 10.32.0.9 dstport 4789 nolearning
ip link set vni91 master brCDN1 addrgenmode none
ip link set vni91 type bridge_slave neigh_suppress on learning off
ip link set vni91 up
ip link set brCDN1 up
ip link set eth6 up
ip link set eth6 master brCDN1 addrgenmode none # CDN1 eth1 interface
ip link set eth6 type bridge_slave neigh_suppress on learning off

# create vlan91 on ether7 interface pointing to Member1
ip link add link eth7 name eth7.91 type vlan id 91
ip link set eth7 up
ip link set eth7.91 up
ip link set eth7.91 master brCDN1 addrgenmode none # Member1 eth1 interface
ip link set eth7.91 type bridge_slave neigh_suppress on learning off

# create vlan2091 on ether8 interface pointing to Member2 and add it to vrfCDN1
ip link add link eth8 name eth8.2091 type vlan id 2091
ip link set eth8 up
ip link set eth8.2091 up
ip link set eth8.2091 master brCDN1 addrgenmode none # Member1 eth1 interface
ip link set eth8.2091 type bridge_slave neigh_suppress on learning off