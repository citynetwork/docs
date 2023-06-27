#!/bin/bash -x

DATADIR=troubleshooting-data
mkdir -p $DATADIR

HOSTNAME=s3-kna1.citycloud.com
IPADDRESSES=`dig +short $HOSTNAME | grep -v '\.$'`
URL="https://s3-kna1.citycloud.com:8080/6a5aa55d8f094a13ae18199639aa72c2:cleura.files/Cleura-Form-Termination-Of-Subscription.pdf"

for ip in $IPADDRESSES; do
    echo "Testing $ip"
    sudo tcpdump -i any -w $DATADIR/tcpdump.$ip.pcap ip host $ip and tcp port 8080 &
    tcpdump_pid=$!
    sleep 3s
    for i in {000..099}; do
        curl -f -o /dev/null --resolve s3-kna1.citycloud.com:8080:$ip -vv $URL 2> $DATADIR/curl.$ip.$i.txt || break
    done
    sudo kill $tcpdump_pid
    echo "Done with $ip"
done
