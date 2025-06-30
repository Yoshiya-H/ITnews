#!/bin/bash

# /proc/net/tcpから直接確認
awk '
BEGIN { print "Proto Local-Address State PID" }
NR > 1 {
    split($2, a, ":")
    port = strtonum("0x" a[2])
    if (port == 323) {
        printf "tcp %s:%d %s\n", a[1], port, $4
    }
}' /proc/net/tcp
