# LAB1


## Addressing

| Device | Interface | IPv4 Address |
| ------ | --------- | ------------ |
| Site A Spine1 | Loopback0 | 10.32.0.1/32 |
| Site A Spine2 | Loopback0 | 10.32.0.2/32 |
| Site A Leaf1 | Loopback0 | 10.32.0.3/32 |
| Site A Leaf2 | Loopback0 | 10.32.0.4/32 |
| Site B Spine1 | Loopback0 | 10.32.0.5/32 |
| Site B Spine2 | Loopback0 | 10.32.0.6/32 |
| Site C Spine1 | Loopback0 | 10.32.0.7/32 |
| Site C Spine2 | Loopback0 | 10.32.0.8/32 |
| Site A Edge1 | Loopback0 | 10.32.0.9/32 |
| Site A Edge2 | Loopback0 | 10.32.0.10/32 |
| Site B Edge1 | Loopback0 | 10.32.0.11/32 |
| Site C Edge1 | Loopback0 | 10.32.0.12/32 |

## Basic configuration

### Site A Spine1

#### *nix
```c
```

#### FRR

```c
frr defaults datacenter
hostname sitea-spine1
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.1/32
exit
!
router bgp 4200000001
 bgp router-id 10.32.0.1
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 neighbor eth11 interface peer-group FABRIC
 neighbor eth12 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site A Spine2

#### *nix
```c
```

#### FRR

```c
frr defaults datacenter
hostname sitea-spine2
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.2/32
exit
!
router bgp 4200000002
 bgp router-id 10.32.0.2
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 neighbor eth11 interface peer-group FABRIC
 neighbor eth12 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site A Leaf1

#### *nix
```c
```

#### FRR

```c
frr defaults datacenter
hostname sitea-leaf1
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.3/32
exit
!
router bgp 4200000003
 bgp router-id 10.32.0.3
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 neighbor eth11 interface peer-group FABRIC
 neighbor eth12 interface peer-group FABRIC
 neighbor eth13 interface peer-group FABRIC
 neighbor eth14 interface peer-group FABRIC
 neighbor eth15 interface peer-group FABRIC
 neighbor eth16 interface peer-group FABRIC
 neighbor eth17 interface peer-group FABRIC
 neighbor eth18 interface peer-group FABRIC
 neighbor eth19 interface peer-group FABRIC
 neighbor eth20 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site A Leaf2

#### *nix
```c
```

#### FRR

```c
frr defaults datacenter
hostname sitea-leaf2
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.4/32
exit
!
router bgp 4200000004
 bgp router-id 10.32.0.4
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 neighbor eth11 interface peer-group FABRIC
 neighbor eth12 interface peer-group FABRIC
 neighbor eth13 interface peer-group FABRIC
 neighbor eth14 interface peer-group FABRIC
 neighbor eth15 interface peer-group FABRIC
 neighbor eth16 interface peer-group FABRIC
 neighbor eth17 interface peer-group FABRIC
 neighbor eth18 interface peer-group FABRIC
 neighbor eth19 interface peer-group FABRIC
 neighbor eth20 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site B Spine1

#### *nix
```c
```

#### FRR

```c
frr defaults datacenter
hostname siteb-spine1
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.5/32
exit
!
router bgp 4200000005
 bgp router-id 10.32.0.5
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site B Spine2

#### *nix

```c
```

#### FRR

```c
frr defaults datacenter
hostname siteb-spine2
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.6/32
exit
!
router bgp 4200000006
 bgp router-id 10.32.0.6
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site C Spine1

#### *nix

```c
```

#### FRR

```c
frr defaults datacenter
hostname sitec-spine1
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.7/32
exit
!
router bgp 4200000007
 bgp router-id 10.32.0.7
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site C Spine2

#### *nix

```c
```

#### FRR

```c
frr defaults datacenter
hostname sitec-spine2
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.8/32
exit
!
router bgp 4200000008
 bgp router-id 10.32.0.8
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 neighbor eth6 interface peer-group FABRIC
 neighbor eth7 interface peer-group FABRIC
 neighbor eth8 interface peer-group FABRIC
 neighbor eth9 interface peer-group FABRIC
 neighbor eth10 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
 exit-address-family
exit
!
end
```

### Site A Edge-1

#### *nix

```c
```

#### FRR

```c
frr defaults datacenter
hostname sitea-edge1
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.9/32
exit
!
router bgp 4200000009
 bgp router-id 10.32.0.9
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
  advertise-all-vni
  advertise-svi-ip
  advertise ipv4 unicast
  advertise ipv6 unicast
 exit-address-family
exit
!
end
```

### Site A Edge-2

#### *nix

```c
```

#### FRR

```c
frr defaults datacenter
hostname sitea-edge2
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.10/32
exit
!
router bgp 4200000010
 bgp router-id 10.32.0.10
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 neighbor eth5 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
  advertise-all-vni
  advertise-svi-ip
  advertise ipv4 unicast
  advertise ipv6 unicast
 exit-address-family
exit
!
end
```

### Site B Edge1

#### *nix

```c
```

#### FRR

```c
frr defaults datacenter
hostname siteb-edge1
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.11/32
exit
!
router bgp 4200000011
 bgp router-id 10.32.0.11
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
  advertise-all-vni
  advertise-svi-ip
  advertise ipv4 unicast
  advertise ipv6 unicast
 exit-address-family
exit
!
end
```

### Site C Edge1

#### *nix

```c
```

#### FRR

```c
frr defaults datacenter
hostname sitec-edge1
service advanced-vty
service password-encryption
!
interface Loopback0
 ip address 10.32.0.12/32
exit
!
router bgp 4200000012
 bgp router-id 10.32.0.12
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 bgp bestpath compare-routerid
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as external
 neighbor FABRIC bfd
 neighbor FABRIC extended-optional-parameters
 neighbor FABRIC advertisement-interval 0
 neighbor FABRIC timers connect 5
 neighbor FABRIC capability extended-nexthop
 neighbor eth1 interface peer-group FABRIC
 neighbor eth2 interface peer-group FABRIC
 neighbor eth3 interface peer-group FABRIC
 neighbor eth4 interface peer-group FABRIC
 !
 address-family ipv4 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family ipv6 unicast
  redistribute connected
  neighbor FABRIC activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
  advertise-all-vni
  advertise-svi-ip
  advertise ipv4 unicast
  advertise ipv6 unicast
 exit-address-family
exit
!
end
```

### PC1

```c
ip address add dev eth1 10.0.0.1/29
ip link set eth1 up
```

### PC2

```c
ip address add dev eth1 10.0.0.2/29
ip link set eth1 up
```

### PC3

```c
ip address add dev eth1 10.0.0.3/29
ip link set eth1 up
```

### PC4

```c
ip address add dev eth1 10.0.0.4/29
ip link set eth1 up
```
