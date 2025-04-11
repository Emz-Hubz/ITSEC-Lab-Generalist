#!/bin/sh
# Simple syslog test script using netcat (UDP)
# Sends a RFC3164-compliant message to a syslog server

SYSLOG_SERVER="10.0.2.20"
SYSLOG_PORT=514
MESSAGE="Test: Syslog test from $(hostname)"

echo "<13>$MESSAGE" | nc -u -w1 $SYSLOG_SERVER $SYSLOG_PORT
