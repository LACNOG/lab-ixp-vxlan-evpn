# This member hast access port to CDN1 VRF
ip link set eth1 up
ip address add dev eth1 10.255.91.18/24
ip -6 address add dev eth1 fd17:2158:6de4:cd1::18/64