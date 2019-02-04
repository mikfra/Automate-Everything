#!/usr/bin/python
import subprocess
import sys
import time 
import netaddr
 
# You will need to add the module netaddr from pip
# Most debian based machines will be able to run "pip install netaddr"
# The modules sys, time, and subprocess should be default to a python installation 
# Information for the netaddr module can be found here: http://netaddr.readthedocs.io/en/latest/
# You will also need to install nmap, not the moudule python-nmap 
 
 
SUBNET_PREFIXLEN = 28 #This will be the subnet length to be divided. Change this to optimize scan results
ip = netaddr.IPNetwork(sys.argv[1])
 
if SUBNET_PREFIXLEN < ip.prefixlen:
    subnet_list = [ip,]
else:
    subnet_list = ip.subnet(SUBNET_PREFIXLEN)
 
for sub in subnet_list:
    cmd = [
            ##'nmap',
            # -sV,                    #Service Scan 
            # -script vuln            #Vuln Scan
            #'-T4',                   #Use Aggresive timings
            #'-open',                 #Only return Open Ports
            #'-sT',                   #SYN Scan
            #'-n',                    #No DNS Resolution
            #'-vvv',                  #Very Very Verbose
            #' --min-rate-10900',     #Set Min Packet transmission rate
            #' --min-hostgroup-256',  #How many hosts to scan at a time
            #' --min-retries-2',      #How many retries per host
            #' -sC',                  #Run script defaults
            #' -Pn',                  #Do not ICMP
            #' -oX', 'out/%s_%s' %(sub.ip, sub.prefixlen) #XML to Stdout
            str(sub)    #Target specification (hostname, IP
                        #addresses, ranges, subnetsm etc.)
            ]
    print ' '.join(cmd)
    #exampe: python tnmap.py 192.168.0.0/11 | xargs -I CMD -P 100 nmap -sT -sV -sC -n -vvv -oX - CMD
