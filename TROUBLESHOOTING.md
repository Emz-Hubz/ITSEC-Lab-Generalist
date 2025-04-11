## Troubleshooting

### Ubuntu Server boots to black screen after install
- Remove the ISO from the CD/DVD drive in GNS3 before rebooting.
- Set boot priority to HDD in VM settings.

### rsyslog errors when enabling UDP input
- Ensure `module(load="imudp")` is declared only once across all `.conf` files.
- Use modern RainerScript syntax:
```bash
action(type="omfile" file="/var/log/remote.log")
```

### Log file permissions issues (rsyslog)
- If user `syslog` does not exist, use:
```bash
sudo chown root:adm /var/log/remote.log
sudo chmod 664 /var/log/remote.log
```

### Debian: Missing network mirror during install
- Ensure the interface is connected to the VyOS router.
- NAT must be active and working before installation begins.
- Use static IP config if DHCP fails.

### TinyCore Linux: No network after boot
- Manually set up IP and routing:
```bash
sudo ifconfig eth0 10.0.1.50 netmask 255.255.255.0 up
sudo route add default gw 10.0.1.1
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### TinyCore Linux: logger -n fails
- Use netcat instead:
```bash
echo "<13>Syslog test" | nc -u -w1 10.0.2.20 514
```

### General Tip: rsyslog syntax errors
- Always restart rsyslog and check status:
```bash
sudo systemctl restart rsyslog
sudo systemctl status rsyslog
```
- Use `tail -f /var/log/syslog` or `journalctl -xe` to debug.

