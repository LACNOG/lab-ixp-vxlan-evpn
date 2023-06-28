# Create bridge and VTEP with VNI 32
ip link add name bridge32 type bridge
ip link set eth5 master bridge32 # connection to PC2 eth1
ip link add vni32 type vxlan local 10.32.0.10 dstport 4789 id 32 nolearning
ip link set vni32 master bridge32 addrgenmode none
ip link set vni32 type bridge_slave neigh_suppress on learning off
ip link set vni32 up
ip link set bridge32 up
