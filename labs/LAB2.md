# LAB2

## Shared CDN provider inside VRF

### Objective

Create a VNI and attach it to a VRF. Configure a shared CDN provider in the VRF. 

CDN1, Member1, Member2, Member7 and Member8 are in the VRF.

### Addressing table

| Device | ASN | Interface | IPv4 address | IPv6 address |
| ------ | --- |  --------- | ------------ | ------------ |
| sitea-edge1 | 64512 | (B) brCDN1 | 10.255.91.1/24 | fd17:2158:6de4:cd1::1/64 |
| cdn1   | 65001 | (U) eth1      | 10.255.91.2/24 | fd17:2158:6de4:cd1::2/64 |
| cdn1 | 65001 | Loopback0 | 198.18.0.1/32 | - |
| cdn1 | 65001 | Loopback0 | 198.18.1.1/32 | - |
| member1 | 65101 | (T) eth1.91 | 10.255.91.11/24 | fd17:2158:6de4:cd1::11/64 |
| member2 | 65102 | (T) eth1.2091 | 10.255.91.12/24 | fd17:2158:6de4:cd1::12/64 |
| member7 | 65107 | (TT) eth1.3232.91 | 10.255.91.17/24 | fd17:2158:6de4:cd1::17/64 |
| member8 | 65108 | (U) eth1 | 10.255.91.18/24 | fd17:2158:6de4:cd1::18/64 |

### Peering Table

| Device | ASN | Advertisement |
| ------ | --- | ------------ |
| member1 | 65101 | 10.101.0.0/16 |
| member1 | 65101 | 10.101.0.0/17 |
| member1 | 65101 | 10.101.128.0/17 |
| member1 | 65101 | 2001:db8:101::/48 |
| member1 | 65101 | 2001:db8:101::/49 |
| member1 | 65101 | 2001:db8:101:8000::/49 |
| member2 | 65102 | 10.102.0.0/16 |
| member2 | 65102 | 10.102.0.0/17 |
| member2 | 65102 | 10.102.128.0/17 |
| member2 | 65102 | 2001:db8:102::/48 |
| member2 | 65102 | 2001:db8:102::/49 |
| member2 | 65102 | 2001:db8:102:8000::/49 |
| member7 | 65107 | 10.102.0.0/16 |
| member7 | 65107 | 10.102.0.0/17 |
| member7 | 65107 | 10.102.128.0/17 |
| member7 | 65107 | 2001:db8:102::/48 |
| member7 | 65107 | 2001:db8:102::/49 |
| member7 | 65107 | 2001:db8:102:8000::/49 |
| member8 | 65108 | 10.102.0.0/16 |
| member8 | 65108 | 10.102.0.0/17 |
| member8 | 65108 | 10.102.128.0/17 |
| member8 | 65108 | 2001:db8:102::/48 |
| member8 | 65108 | 2001:db8:102::/49 |
| member8 | 65108 | 2001:db8:102:8000::/49 |

#### Configure CDN1

```txt
frr defaults traditional
hostname cdn1
log syslog informational
service advanced-vty
service password-encryption
!
ip route 198.18.0.0/23 Null0 250
ip route 198.18.0.0/24 Null0 250
ip route 198.18.1.0/24 Null0 250
ipv6 route 2001:db8:cd1::/48 Null0 250
!
interface Loopback0
 ip address 198.18.0.1/32
 ip address 198.18.1.1/32
exit
!
interface eth1
 ip address 10.255.91.2/24
 ipv6 address fd17:2158:6de4:cd1::2/64
exit
!
router bgp 65001
 bgp router-id 198.18.0.1
 bgp log-neighbor-changes
 no bgp default ipv4-unicast
 bgp default show-hostname
 bgp default show-nexthop-hostname
 bgp deterministic-med
 timers bgp 3 9
 neighbor 10.255.91.1 remote-as 64512
 neighbor 10.255.91.1 timers connect 10
 neighbor fd17:2158:6de4:cd1::1 remote-as 64512
 neighbor fd17:2158:6de4:cd1::1 timers connect 10
 !
 address-family ipv4 unicast
  network 198.18.0.0/23
  network 198.18.0.0/24
  network 198.18.1.0/24
  neighbor 10.255.91.1 activate
  neighbor 10.255.91.1 route-map IXP-IN in
  neighbor 10.255.91.1 route-map IXP-OUT out
 exit-address-family
 !
 address-family ipv6 unicast
  network 2001:db8:cd1::/48
  neighbor fd17:2158:6de4:cd1::1 activate
  neighbor fd17:2158:6de4:cd1::1 route-map IXP-IN in
  neighbor fd17:2158:6de4:cd1::1 route-map IXP-OUT out
 exit-address-family
exit
!
ip prefix-list BGPv4-IN seq 5 permit 0.0.0.0/0 le 24
ip prefix-list BGPv4-OUT seq 5 permit 198.18.0.0/15 le 24
!
ipv6 prefix-list BGPv6-OUT seq 5 permit 2001:db8:cd1::/48 le 56
ipv6 prefix-list BGPv6-IN seq 5 permit ::/0 le 48
!
route-map IXP-IN permit 1000
 match ipv6 address prefix-list BGPv6-IN
exit
!
route-map IXP-IN permit 2000
 match ipv6 address prefix-list BGPv6-IN
exit
!
route-map IXP-OUT permit 1000
 match ip address prefix-list BGPv4-OUT
exit
!
route-map IXP-OUT permit 2000
 match ipv6 address prefix-list BGPv6-OUT
exit
!
route-map IXP-OUT deny 65535
exit
!
end
```

#### Configure Linux @sitea-edge1

```bash
## IPFRF CDN1 / L3VNI 91

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
ip link set eth6 master brCDN1 addrgenmode none # CDN1 eth1 interface
ip link set eth6 type bridge_slave neigh_suppress on learning off
```

#### Configure FRR @sitea-edge1

```txt
configure terminal
!
vrf vrfCDN1
 vni91
exit-vrf
!
router bgp 4200000009 vrf vrfCDN1
 no bgp default ipv4-unicast
 !
 address-family ipv4 unicast
  redistribute static
  redistribute connected
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute static
  redistribute connected
 exit-address-family
 !
 address-family l2vpn evpn
  advertise ipv4 unicast
  advertise ipv6 unicast
 exit-address-family
!
interface brCDN1
 ip address 10.255.91.1/24
 ipv6 address fd17:2158:6de4:cd1::1/64
exit
!
end
```

#### Configure BGP policing @sitea-edge1

```txt
!
ip prefix-list CDN1 seq 5 permit 198.18.0.0/15 le 24
!
ipv6 prefix-list CDN1 seq 5 permit 2001:db8:cd1::/48 le 56
!
route-map PERMIT permit 1
exit
!
route-map CDN1-IN permit 1000
 match ip address prefix-list CDN1
exit
!
router bgp 4200000009 vrf vrfCDN1
 neighbor 10.255.91.2 remote-as 65001
 neighbor 10.255.91.2 local-as 64512
 neighbor 10.255.91.2 description CDN1 IPv4 AS65001
 neighbor fd17:2158:6de4:cd1::2 remote-as 65001
 neighbor fd17:2158:6de4:cd1::2 local-as 64512
 neighbor fd17:2158:6de4:cd1::2 description CDN1 IPv6 AS65001
 !
 address-family ipv4 unicast
  neighbor 10.255.91.2 activate
  neighbor 10.255.91.2 route-map CDN1-IN in
  neighbor 10.255.91.2 route-map PERMIT out
  rd vpn export 64512:91
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  redistribute static
  neighbor fd17:2158:6de4:cd1::2 activate
  neighbor fd17:2158:6de4:cd1::2 route-map CDN1-IN in
  neighbor fd17:2158:6de4:cd1::2 route-map PERMIT out
 exit-address-family
!
```

```txt
siteb-edge1# sh bgp l2vpn evpn 
BGP table version is 38, local router ID is 10.32.0.11
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal
Origin codes: i - IGP, e - EGP, ? - incomplete
EVPN type-1 prefix: [1]:[EthTag]:[ESI]:[IPlen]:[VTEP-IP]:[Frag-id]
EVPN type-2 prefix: [2]:[EthTag]:[MAClen]:[MAC]:[IPlen]:[IP]
EVPN type-3 prefix: [3]:[EthTag]:[IPlen]:[OrigIP]
EVPN type-4 prefix: [4]:[ESI]:[IPlen]:[OrigIP]
EVPN type-5 prefix: [5]:[EthTag]:[IPlen]:[IP]

   Network          Next Hop            Metric LocPrf Weight Path
Route Distinguisher: 10.32.0.9:2
 *  [2]:[0]:[48]:[46:10:46:c7:b4:4c]:[128]:[fe80::4410:46ff:fec7:b44c]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.9]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 i
                    RT:59913:32 ET:8
Route Distinguisher: 10.32.0.10:2
 *  [2]:[0]:[48]:[22:e0:d0:74:13:eb]:[128]:[fe80::20e0:d0ff:fe74:13eb]
                    10.32.0.10(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
 *                   10.32.0.10(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
 *>                  10.32.0.10(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
 *                   10.32.0.10(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.10]
                    10.32.0.10(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
 *                   10.32.0.10(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
 *>                  10.32.0.10(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
 *                   10.32.0.10(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000010 i
                    RT:59914:32 ET:8
Route Distinguisher: 10.32.0.12:2
 *  [2]:[0]:[48]:[02:42:64:40:00:0f]:[128]:[fe80::42:64ff:fe40:f]
                    10.32.0.12(siteb-spine1)
                                                           0 4200000005 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *                   10.32.0.12(siteb-spine1)
                                                           0 4200000005 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *                   10.32.0.12(siteb-spine2)
                                                           0 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *>                  10.32.0.12(siteb-spine2)
                                                           0 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *  [2]:[0]:[48]:[02:42:9b:f1:71:ed]
                    10.32.0.12(siteb-spine1)
                                                           0 4200000005 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *                   10.32.0.12(siteb-spine1)
                                                           0 4200000005 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *                   10.32.0.12(siteb-spine2)
                                                           0 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *>                  10.32.0.12(siteb-spine2)
                                                           0 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *  [3]:[0]:[32]:[10.32.0.12]
                    10.32.0.12(siteb-spine1)
                                                           0 4200000005 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *                   10.32.0.12(siteb-spine1)
                                                           0 4200000005 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *                   10.32.0.12(siteb-spine2)
                                                           0 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
 *>                  10.32.0.12(siteb-spine2)
                                                           0 4200000006 4200000007 4200000012 i
                    RT:59916:32 ET:8
Route Distinguisher: 10.255.91.1:3
 *  [5]:[0]:[23]:[198.18.0.0]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *  [5]:[0]:[24]:[10.255.91.0]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *  [5]:[0]:[24]:[198.18.0.0]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *  [5]:[0]:[24]:[198.18.1.0]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *  [5]:[0]:[48]:[2001:db8:cd1::]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 64512 65001 i
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *  [5]:[0]:[64]:[fd17:2158:6de4:cd1::]
                    10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine2)
                                                           0 4200000006 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *>                  10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91
 *                   10.32.0.9(siteb-spine1)
                                                           0 4200000005 4200000003 4200000001 4200000009 ?
                    RT:59913:91 ET:8 Rmac:aa:bb:cc:00:00:91

Displayed 13 out of 52 total prefixes
```