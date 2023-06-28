# Create bridge and VTEP with VNI 32 and add eth0 to it
ip link add name bridge32 type bridge
ip link set eth0 master bridge32 # connection to management network in eth0
ip link add vni32 type vxlan local 10.32.0.12 dstport 4789 id 32 nolearning
ip link set vni32 master bridge32 addrgenmode none
ip link set vni32 type bridge_slave neigh_suppress on learning off
ip link set vni32 up
ip link set bridge32 up

# Create IPFRF CDN1 / L3VNI 91
ip link add vrfCDN1 type vrf table 1091
ip link set vrfCDN1 up
ip link add brCDN1 type bridge
ip link set brCDN1 master vrfCDN1 addrgenmode none
ip link set brCDN1 addr aa:bb:cc:00:00:9C
ip link add vni91 type vxlan id 91 local 10.32.0.12 dstport 4789 nolearning
ip link set vni91 master brCDN1 addrgenmode none
ip link set vni91 type bridge_slave neigh_suppress on learning off
ip link set vni91 up
ip link set brCDN1 up

# create vlan qinq 3232.91 on ether7 interface pointing to Member7
ip link add link eth7 name eth7.3232 type vlan id 3232 protocol 802.1ad
ip link add link eth7 name eth7.3232.91 type vlan id 91
ip link set eth7 up
ip link set eth7.3232 up
ip link set eth7.3232.91 up
ip link set eth7.3232.91 master brCDN1 addrgenmode none # Member7 eth1 interface
ip link set eth7.3232.91 type bridge_slave neigh_suppress on learning off

