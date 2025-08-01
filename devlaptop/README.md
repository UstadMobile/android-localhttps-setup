# Developer laptop setup

* Install apache2 and enable mod ssl:

```
sudo a2enmod ssl
sudo systemctl restart apache2
```

* Generate the bundle for running https locally on the [server](../server/] and copy the .zip to the developer's laptop.
* Unzip and run install script to copy files into place:

```
unzip (bundle-name)
cd (bundle-name)
chmod a+x install.sh
sudo install.sh
sudo systemctl restart apache2
```

* Modify /etc/hosts and add a line with the laptop's local IP address and the localdev.DOMAIN e.g.

```
192.168.1.2 localdev.testing.example.org
```

* You should now be able to open https://localdev.DOMAIN/ on your laptop (where DOMAIN is it was set when making the bundle on 
  the server . This should also work on any Android emulator running on the laptop.

* Install DNSMasq to provide a DNS server for Android Devices on the same WiFi network (replace 192.168.1.2 with the laptop's
  actual local IP address):

```
sudo apt-get install dnsmasq
sudo sed "s/IPADDR/192.168.1.2/g" templates/dnsmasq.conf > /etc/dnsmasq.conf
sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq
```

* The setup can be tested using the dig command (should provide the laptop local IP address for the local testing domain 
  (DNSMasq will get this from /etc/hosts), and it should also resolve any other IP using Ubuntu's systemd-resolved as per
  the config template.

```
dig @192.168.1.2 localdev.testing.example.org
dig @192.168.1.2 google.com
```

* On an Android device go to WiFi settings, then change the IP setting from DHCP to static. Put in the laptop IP address
  (e.g. 192.168.1.2) as DNS server 1, and set DNS server 2 to be blank. Save/apply the settings.

* The Android phone should now a) still be able to connect to the Internet as normal and b) should be able to connect to
  the local testing domain using https (e.g. https://localdev.testing.example.org/).

### DNSMasq config notes:

DNSMasq needs to be set to run on the local network IP address and NOT listen on any other IP address (otherwise
there will be a port conflict with systemd-resolved).

* Uncomment ```strict-order```, ```bind-interfaces```, ```no-resolv```.
* Under ```no-resolv``` add ```server=127.0.0.53``` - this uses Ubuntu's systemd-resolved as the
  the upstream DNS server.
* Set listen-address to the IP address of the developer's laptop ```listen-address=```
