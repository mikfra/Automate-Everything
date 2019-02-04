#!/bin/bash

#Simple bash script to monitor network usage

#The colour code consists of three parts:
#The first part before the semicolon represents the text style.
#00=none, 01=bold, 04=underscore, 05=blink, 07=reverse, 08=concealed.

#The second and third part are the colour and the background color:
#30=black, 31=red, 32=green, 33=yellow, 34=blue, 35=magenta, 36=cyan, 37=white.


read -p "interface= (-i interface or leave blank for none): " -r q
sudo tcpdump -v $q | GREP_COLOR='05;37' egrep --color=always $HOSTNAME \
| GREP_COLOR='01;31' egrep -i --color=always 'https|http|' \
| GREP_COLOR='05;33' egrep -i --color=always 'ssh|SSH|ICMP|' \
| GREP_COLOR='01;32' egrep -i --color=always "amazon|comcast|verizon|google|akami|windstream|microsoft|penteledata" \
| GREP_COLOR='04;32' egrep -i --color=always "ec2|s3|gcp|ptd"
