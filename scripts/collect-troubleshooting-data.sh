#!/bin/bash -x

DATADIR=troubleshooting-data
mkdir -p $DATADIR

HOSTNAME=s3-kna1.citycloud.com
IPADDRESSES=`dig +short $HOSTNAME | grep -v '\.$'`
TIMEOUT=60
URL="https://s3-kna1.citycloud.com:8080/6a5aa55d8f094a13ae18199639aa72c2:cleura.files/Cleura-Form-Termination-Of-Subscription.pdf"

curl -H "Accept: application/json" https://ifconfig.co/json > $DATADIR/ifconfig.co.json
curl -H "Accept: text/plain" https://icanhazip.com > $DATADIR/client_ip.txt
for ip in $IPADDRESSES; do
    echo "Testing $ip"
    ping -D -c 5 -w 15 $ip > $DATADIR/ping.$ip.txt 2>&1
    # timeout -v $TIMEOUT tracepath $ip > $DATADIR/tracepath.$ip.txt 2>&1
    timeout -v $TIMEOUT mtr -Twzeb -P 8080 $ip > $DATADIR/mtr.$ip.txt 2>&1

    sudo tcpdump -i any -w tcpdump.$ip.pcap ip host $ip and tcp port 8080 &
    tcpdump_pid=$!
    sleep 3s
    curl -f -o /dev/null --resolve s3-kna1.citycloud.com:8080:$ip -vv $URL
    sudo kill $tcpdump_pid
    sleep 3s
    sudo kill -9 $tcpdump_pid
    echo "Done with $ip"
done
