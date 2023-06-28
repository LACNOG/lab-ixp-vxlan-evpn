# LAB1

## Shared management network

### Objective

PC1 and PC2 are used by the Network Operating Center of the IXP. This computers are connected to the `VLAN/VNI 32`, which includes all of the management interfaces of the IXP devices (defined as *eth0* for every device in this example).

The objective of this lab is to configure the management network of the IXP, so that PC1 and PC2 can reach all of the devices in the IXP with the following subnets:

* 100.64.0.0/24
* 2001:db8::/64

### Configuration

#### IP Addressing

| Device | Interface | IPv4 Address | IPv6 Address |
| ------ | --------- | ------------ | ------------ |
| PC1 | eth1 | 100.64.0.129/24 | 2001:db8::129/64 |
| PC2 | eth1 | 100.64.0.130/24 | 2001:db8::130/64 |

#### PC1 & PC2

```bash
# Remove configuration from eth0 interface
# PC1 and PC2
ifconfig eth0 0 down

ip address add dev eth1 100.64.0.X/24 # X = 129 for PC1, X = 130 for PC2
ip -6 address add dev eth1 2001:db8::X/64 # X = 129 for PC1, X = 130 for PC2
```

#### sitea-edge1
    
```bash
# Create bridge and VTEP with VNI 32
ip link add name bridge32 type bridge
ip link set eth5 master bridge32 # connection to PC1 eth1
ip link add vni32 type vxlan local 10.32.0.9 dstport 4789 id 32 nolearning
ip link set vni32 master bridge32 addrgenmode none
ip link set vni32 type bridge_slave neigh_suppress on learning off
ip link set vni32 up
ip link set bridge32 up
```

#### sitea-edge2

```bash
# Create bridge and VTEP with VNI 32
ip link add name bridge32 type bridge
ip link set eth5 master bridge32 # connection to PC2 eth1
ip link add vni32 type vxlan local 10.32.0.10 dstport 4789 id 32 nolearning
ip link set vni32 master bridge32 addrgenmode none
ip link set vni32 type bridge_slave neigh_suppress on learning off
ip link set vni32 up
ip link set bridge32 up
```

#### sitec-edge1

I've chosen this site to demonstrate you can connect any site to the overlay network, even if it's not near the other sites.

All traffic going to the management network or default free zone will *land* here before being routed to the rest of the internet.

```bash
# Create bridge and VTEP with VNI 32
ip link add name bridge32 type bridge
ip link set eth0 master bridge32 # connection to management network in eth0
ip link add vni32 type vxlan local 10.32.0.12 dstport 4789 id 32 nolearning
ip link set vni32 master bridge32 addrgenmode none
ip link set vni32 type bridge_slave neigh_suppress on learning off
ip link set vni32 up
ip link set bridge32 up
```

#### Check remote MAC in sitea-edge1

```txt
sitea-edge1# show evpn mac vni 32
Number of MACs (local and remote) known for this VNI: 5
Flags: N=sync-neighs, I=local-inactive, P=peer-active, X=peer-proxy
MAC               Type   Flags Intf/Remote ES/VTEP            VLAN  Seq #'s
22:e0:d0:74:13:eb remote       10.32.0.10                           0/0
aa:c1:ab:77:53:e3 local        eth5                                 0/0
46:10:46:c7:b4:4c local        bridge32                       1     0/0
02:42:64:40:00:0f remote       10.32.0.12                           0/0
02:42:9b:f1:71:ed remote       10.32.0.12                           0/0
```

#### Check remote MAC in sitea-edge2

```txt
sitea-edge2# show evpn mac vni 32
Number of MACs (local and remote) known for this VNI: 5
Flags: N=sync-neighs, I=local-inactive, P=peer-active, X=peer-proxy
MAC               Type   Flags Intf/Remote ES/VTEP            VLAN  Seq #'s
22:e0:d0:74:13:eb local        bridge32                       1     0/0
aa:c1:ab:77:53:e3 remote       10.32.0.9                            0/0
46:10:46:c7:b4:4c remote       10.32.0.9                            0/0
02:42:64:40:00:0f remote       10.32.0.12                           0/0
02:42:9b:f1:71:ed remote       10.32.0.12                           0/0
```

#### Check remote MAC in sitec-edge1

```txt
sitec-edge1# show evpn mac vni 32
Number of MACs (local and remote) known for this VNI: 5
Flags: N=sync-neighs, I=local-inactive, P=peer-active, X=peer-proxy
MAC               Type   Flags Intf/Remote ES/VTEP            VLAN  Seq #'s
22:e0:d0:74:13:eb remote       10.32.0.10                           0/0
aa:c1:ab:77:53:e3 remote       10.32.0.9                            0/0
46:10:46:c7:b4:4c remote       10.32.0.9                            0/0
02:42:64:40:00:0f local        bridge32                       1     0/0
02:42:9b:f1:71:ed local        eth0                                 0/0

```
#### Show BGP EVPN routes in sitea-edge2

```txt
sitea-edge2# show bgp l2vpn evpn route vni 32
BGP table version is 12, local router ID is 10.32.0.10
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal
Origin codes: i - IGP, e - EGP, ? - incomplete
EVPN type-1 prefix: [1]:[EthTag]:[ESI]:[IPlen]:[VTEP-IP]:[Frag-id]
EVPN type-2 prefix: [2]:[EthTag]:[MAClen]:[MAC]:[IPlen]:[IP]
EVPN type-3 prefix: [3]:[EthTag]:[IPlen]:[OrigIP]
EVPN type-4 prefix: [4]:[ESI]:[IPlen]:[OrigIP]
EVPN type-5 prefix: [5]:[EthTag]:[IPlen]:[IP]

   Network          Next Hop            Metric LocPrf Weight Path
 *  [2]:[0]:[48]:[02:42:64:40:00:0f]:[128]:[fe80::42:64ff:fe40:f]
                    10.32.0.12(sitea-spine2)
                                                           0 4200000002 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8
 *  [2]:[0]:[48]:[02:42:64:40:00:0f]:[128]:[fe80::42:64ff:fe40:f]
                    10.32.0.12(sitea-spine2)
                                                           0 4200000002 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8
 *  [2]:[0]:[48]:[02:42:64:40:00:0f]:[128]:[fe80::42:64ff:fe40:f]
                    10.32.0.12(sitea-spine1)
                                                           0 4200000001 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8
 *> [2]:[0]:[48]:[02:42:64:40:00:0f]:[128]:[fe80::42:64ff:fe40:f]
                    10.32.0.12(sitea-spine1)
                                                           0 4200000001 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8
 *> [2]:[0]:[48]:[22:e0:d0:74:13:eb]:[128]:[fe80::20e0:d0ff:fe74:13eb]
                    10.32.0.10(sitea-edge2)
                                                       32768 i
                    ET:8 RT:59914:32
 *> [2]:[0]:[48]:[46:10:46:c7:b4:4c]:[128]:[fe80::4410:46ff:fec7:b44c]
                    10.32.0.9(sitea-spine1)
                                                           0 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *  [2]:[0]:[48]:[46:10:46:c7:b4:4c]:[128]:[fe80::4410:46ff:fec7:b44c]
                    10.32.0.9(sitea-spine2)
                                                           0 4200000002 4200000009 i
                    RT:59913:32 ET:8
 *  [2]:[0]:[48]:[46:10:46:c7:b4:4c]:[128]:[fe80::4410:46ff:fec7:b44c]
                    10.32.0.9(sitea-spine1)
                                                           0 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *  [2]:[0]:[48]:[46:10:46:c7:b4:4c]:[128]:[fe80::4410:46ff:fec7:b44c]
                    10.32.0.9(sitea-spine2)
                                                           0 4200000002 4200000009 i
                    RT:59913:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.9]
                    10.32.0.9(sitea-spine2)
                                                           0 4200000002 4200000009 i
                    RT:59913:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.9]
                    10.32.0.9(sitea-spine2)
                                                           0 4200000002 4200000009 i
                    RT:59913:32 ET:8
 *> [3]:[0]:[32]:[10.32.0.9]
                    10.32.0.9(sitea-spine1)
                                                           0 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.9]
                    10.32.0.9(sitea-spine1)
                                                           0 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *> [3]:[0]:[32]:[10.32.0.10]
                    10.32.0.10(sitea-edge2)
                                                       32768 i
                    ET:8 RT:59914:32
 *  [3]:[0]:[32]:[10.32.0.12]
                    10.32.0.12(sitea-spine1)
                                                           0 4200000001 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8
 *> [3]:[0]:[32]:[10.32.0.12]
                    10.32.0.12(sitea-spine1)
                                                           0 4200000001 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.12]
                    10.32.0.12(sitea-spine2)
                                                           0 4200000002 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.12]
                    10.32.0.12(sitea-spine2)
                                                           0 4200000002 4200000004 4200000008 4200000012 i
                    RT:59916:32 ET:8

Displayed 6 prefixes (18 paths)
```

#### Check connectivity from PC1 to PC2

```txt
bash-5.1# ping -c5  100.64.0.130
PING 100.64.0.130 (100.64.0.130) 56(84) bytes of data.
64 bytes from 100.64.0.130: icmp_seq=1 ttl=64 time=0.131 ms
64 bytes from 100.64.0.130: icmp_seq=2 ttl=64 time=0.085 ms
64 bytes from 100.64.0.130: icmp_seq=3 ttl=64 time=0.092 ms
64 bytes from 100.64.0.130: icmp_seq=4 ttl=64 time=0.094 ms
64 bytes from 100.64.0.130: icmp_seq=5 ttl=64 time=0.109 ms

--- 100.64.0.130 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4099ms
rtt min/avg/max/mdev = 0.085/0.102/0.131/0.016 ms

bash-5.1# ping6 -c5 2001:db8::130
PING 2001:db8::130(2001:db8::130) 56 data bytes
64 bytes from 2001:db8::130: icmp_seq=1 ttl=64 time=0.427 ms
64 bytes from 2001:db8::130: icmp_seq=2 ttl=64 time=0.086 ms
64 bytes from 2001:db8::130: icmp_seq=3 ttl=64 time=0.098 ms
64 bytes from 2001:db8::130: icmp_seq=4 ttl=64 time=0.098 ms
64 bytes from 2001:db8::130: icmp_seq=5 ttl=64 time=0.085 ms

--- 2001:db8::130 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4087ms
rtt min/avg/max/mdev = 0.085/0.158/0.427/0.134 ms
```

#### Check access to management devices

```txt
bash-5.1# nmap -sP 100.64.0.0/24
Starting Nmap 7.92 ( https://nmap.org ) at 2023-06-27 21:09 UTC
Nmap scan report for 100.64.0.1
Host is up (0.00029s latency).
MAC Address: 02:42:9B:F1:71:ED (Unknown)
Nmap scan report for lab-ixp-cdn1.lacnog_mng (100.64.0.2)
Host is up (0.000071s latency).
MAC Address: 02:42:64:40:00:02 (Unknown)
Nmap scan report for lab-ixp-member5.lacnog_mng (100.64.0.3)
Host is up (0.000078s latency).
MAC Address: 02:42:64:40:00:03 (Unknown)
Nmap scan report for lab-ixp-sitec-spine2.lacnog_mng (100.64.0.4)
Host is up (0.000080s latency).
MAC Address: 02:42:64:40:00:04 (Unknown)
Nmap scan report for lab-ixp-member4.lacnog_mng (100.64.0.5)
Host is up (0.000081s latency).
MAC Address: 02:42:64:40:00:05 (Unknown)
Nmap scan report for lab-ixp-siteb-spine2.lacnog_mng (100.64.0.6)
Host is up (0.000076s latency).
MAC Address: 02:42:64:40:00:06 (Unknown)
Nmap scan report for lab-ixp-sitea-spine1.lacnog_mng (100.64.0.7)
Host is up (0.000064s latency).
MAC Address: 02:42:64:40:00:07 (Unknown)
Nmap scan report for lab-ixp-sitea-leaf1.lacnog_mng (100.64.0.8)
Host is up (0.000077s latency).
MAC Address: 02:42:64:40:00:08 (Unknown)
Nmap scan report for lab-ixp-cdn3.lacnog_mng (100.64.0.11)
Host is up (0.00010s latency).
MAC Address: 02:42:64:40:00:0B (Unknown)
Nmap scan report for lab-ixp-sitea-spine2.lacnog_mng (100.64.0.12)
Host is up (0.00013s latency).
MAC Address: 02:42:64:40:00:0C (Unknown)
Nmap scan report for lab-ixp-member8.lacnog_mng (100.64.0.13)
Host is up (0.00011s latency).
MAC Address: 02:42:64:40:00:0D (Unknown)
Nmap scan report for lab-ixp-cdn4.lacnog_mng (100.64.0.14)
Host is up (0.000068s latency).
MAC Address: 02:42:64:40:00:0E (Unknown)
Nmap scan report for lab-ixp-sitec-edge1.lacnog_mng (100.64.0.15)
Host is up (0.000064s latency).
MAC Address: 02:42:64:40:00:0F (Unknown)
Nmap scan report for lab-ixp-siteb-edge1.lacnog_mng (100.64.0.16)
Host is up (0.000057s latency).
MAC Address: 02:42:64:40:00:10 (Unknown)
Nmap scan report for lab-ixp-sitea-edge1.lacnog_mng (100.64.0.17)
Host is up (0.000020s latency).
MAC Address: 02:42:64:40:00:11 (Unknown)
Nmap scan report for lab-ixp-member2.lacnog_mng (100.64.0.18)
Host is up (0.000071s latency).
MAC Address: 02:42:64:40:00:12 (Unknown)
Nmap scan report for lab-ixp-sitec-spine1.lacnog_mng (100.64.0.19)
Host is up (0.000073s latency).
MAC Address: 02:42:64:40:00:13 (Unknown)
Nmap scan report for lab-ixp-member3.lacnog_mng (100.64.0.20)
Host is up (0.000070s latency).
MAC Address: 02:42:64:40:00:14 (Unknown)
Nmap scan report for lab-ixp-member1.lacnog_mng (100.64.0.21)
Host is up (0.00015s latency).
MAC Address: 02:42:64:40:00:15 (Unknown)
Nmap scan report for lab-ixp-member6.lacnog_mng (100.64.0.22)
Host is up (0.00044s latency).
MAC Address: 02:42:64:40:00:16 (Unknown)
Nmap scan report for lab-ixp-sitea-leaf2.lacnog_mng (100.64.0.23)
Host is up (0.00044s latency).
MAC Address: 02:42:64:40:00:17 (Unknown)
Nmap scan report for lab-ixp-member7.lacnog_mng (100.64.0.24)
Host is up (0.00044s latency).
MAC Address: 02:42:64:40:00:18 (Unknown)
Nmap scan report for lab-ixp-sitea-edge2.lacnog_mng (100.64.0.25)
Host is up (0.00036s latency).
MAC Address: 02:42:64:40:00:19 (Unknown)
Nmap scan report for lab-ixp-siteb-spine1.lacnog_mng (100.64.0.26)
Host is up (0.00044s latency).
MAC Address: 02:42:64:40:00:1A (Unknown)
Nmap scan report for lab-ixp-cdn2.lacnog_mng (100.64.0.28)
Host is up (0.00044s latency).
MAC Address: 02:42:64:40:00:1C (Unknown)
Nmap scan report for 100.64.0.130
Host is up (0.000085s latency).
MAC Address: AA:C1:AB:FB:51:7A (Unknown)
Nmap scan report for 100.64.0.129
Host is up.
Nmap done: 256 IP addresses (27 hosts up) scanned in 1.89 seconds
```

#### Check conectivity to internet

```txt
bash-5.1# ip route add default via 100.64.0.1
bash-5.1# dig @1.1.1.1 lacnog.org

; <<>> DiG 9.16.22 <<>> @1.1.1.1 lacnog.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 44229
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;lacnog.org.                    IN      A

;; ANSWER SECTION:
lacnog.org.             3600    IN      A       151.101.1.195
lacnog.org.             3600    IN      A       151.101.65.195

;; Query time: 180 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Tue Jun 27 21:08:42 UTC 2023
;; MSG SIZE  rcvd: 71

bash-5.1# ping -c5 lacnog.org
PING lacnog.org (151.101.65.195) 56(84) bytes of data.
64 bytes from 151.101.65.195 (151.101.65.195): icmp_seq=1 ttl=56 time=13.0 ms
64 bytes from 151.101.65.195 (151.101.65.195): icmp_seq=2 ttl=56 time=14.6 ms
64 bytes from 151.101.65.195 (151.101.65.195): icmp_seq=3 ttl=56 time=16.8 ms
64 bytes from 151.101.65.195 (151.101.65.195): icmp_seq=4 ttl=56 time=14.6 ms
64 bytes from 151.101.65.195 (151.101.65.195): icmp_seq=5 ttl=56 time=11.9 ms

--- lacnog.org ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4004ms
rtt min/avg/max/mdev = 11.889/14.148/16.771/1.659 ms
```