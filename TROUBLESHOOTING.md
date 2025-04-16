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
sudo ifconfig eth0 Y.X.0.0netmask 255.255.255.0 up
sudo route add default gw X.Y.O.1
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### TinyCore Linux: logger -n fails
- Use netcat instead:
```bash
echo "<13>Syslog test" | nc -u -w1 X.C.Y.20 514
```

### General Tip: rsyslog syntax errors
- Always restart rsyslog and check status:
```bash
sudo systemctl restart rsyslog
sudo systemctl status rsyslog
```
- Use `tail -f /var/log/syslog` or `journalctl -xe` to debug.

### Issue: `ens4` shows `NO-CARRIER` even after setting `promisc` mode

**Symptom:**
After enabling promiscuous mode on `ens4`:

```bash
sudo ip link set ens4 promisc on
```

The output of `ip link show ens4` shows:

```
<NO-CARRIER,BROADCAST,MULTICAST,PROMISC,UP>
```

And `ethtool ens4` returns:

```
Link detected: no
```

**Cause:**
The second network adapter (ens4 / Ethernet1) on the IDS machine is not physically connected in GNS3 – meaning it’s not receiving any link signal. This is often caused by incorrect wiring between the IDS, the hub, and the VyOS router.

**Solution:**

1. **Verify adapter setup in GNS3:**
   - Right-click IDS → Configure → Network → Custom Adapters
   - Ensure that **Adapter 1 (Ethernet1)** is enabled and set to `e1000`

2. **Correct the cable setup:**
   - Connect **Ethernet1 (Adapter 1)** on IDS to **port e2** on the hub
   - Ensure the hub is already connected to **VyOS eth1**

3. **Restart the IDS machine**

4. **Validate:**
   Run:

   ```bash
   ip link show ens4
   ```

   You should now see:

   ```
   <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP>
   ```

   and:

   ```bash
   ethtool ens4
   ```

   should show:

   ```
   Link detected: yes
   ```

