# Android HTTPS local development scripts

HTTPS is required for (and thus to fully test):

* [App links](https://developer.android.com/training/app-links/verify-android-applinks)
* Passkeys

Passkeys are now the recommended way to signup users - great! But how can you test run these app
components on your laptop now? App links can be manually enabled through app settings, but there's 
no such thing for passkeys.

Using any self-signed certificate won't work because the [Digital Asset Links API](https://developers.google.com/digital-asset-links/reference/rest)
depends on Google's cache.

This can be done using:

* **An https-enabled domain (or subdomain) that works on the public Internet** (e.g. a continuous integration server). 
  This is used to host the assetlinks.json that must be verified e.g. ```testing.example.org```
* **An APK that includes app link filters and asset statements** for the test domain itself and wildcard subdomain e.g.
AndoridManifest.xml: 
```
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />

    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />

    <data android:scheme="https" />
    <data android:host="*.testing.example.org" />
    <data android:host="testing.example.org" />
</intent-filter>
```
asset_statements.xml:
```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="asset_statements" translatable="false">
    [{
      \"include\": \"https://testing.example.org/.well-known/assetlinks.json\"
    }]
    </string>
</resources>
```

* **Copying the certbot configuration and keys to the developer's laptop** - enabling Apache on the 
  developer's laptop to provide a valid https response for this specific testing domain.
* **Setting the IP address for localdev.testing.example.org in /etc/hosts** so that the laptop's browser
  and any Android emulators running will connect to the developer laptop's local IP address.
* **Running DNSMasq on the developer's laptop** that will return the developer laptop's local IP address for
  localdev.testing.example.org, then changing the WiFi settings on physical Android devices to use this
  DNS server. This allows Android devices on the same WiFi network to connect to the developer's laptop 
  using https.


See server and devlaptop folders for instructions.





These scripts are written for Ubuntu Linux (probably fine on similar distros). This is example is written where:
* 192.168.1.5 is the IP address of the developer's laptop
* testproxy.devserver3.ustadmobile.com is the 'top' domain that is used to host the assetlinks.json
  file
* localdev.testproxy.devserver3.ustadmobile.com is the subdomain used for local developers to run
  https

The system works as follows:
* A test domain/subdomain is setup (e.g. testproxy.devserver3.ustadmobile.com). The assetlinks include
  the SHA-256 fingerprint used on any APK that is going to be tested. This makes the assetlinks.json
  accessible ( e.g. ```https://testproxy.devserver3.ustadmobile.com/.well-known/assetlinks.json```
  accessible from the public internet as required). The test domain is setup using a wildcard SSL
  certificate (e.g. from certbot or other public registry).
```
* The APK asset_statements includes the link to assetlinks.json e.g.


Local development setup:

Local development is done by having the developer download and setup an https certificate for a 
specific subdomain (e.g. localdev.testproxy.devserver3.ustadmobile.com ) on their laptop. 



Manual instructions:

* Use with emulator: Add the domain to /etc/hosts e.g.
```
192.168.1.5 localdev.testproxy.devserver3.ustadmobile.com
```
* Device: this is handled by installing DNSMasq DNS server on the developer's laptop and then 
  setting the developer laptop's IP address as the DNS server for the WiFi network.
  * Install dnsmasq ```apt-get install dnsmasq```
  * In ```/etc/dnsmasq.conf```
    * Uncomment ```strict-order```, ```bind-interfaces```, ```no-resolv```.
    * Under ```no-resolv``` add ```server=127.0.0.53``` - this uses Ubuntu's systemd-resolved as the
      the upstream DNS server.
    * Set listen-address to the IP address of the developer's laptop ```listen-address=```
  * Create a new file ```/etc/dnsmasq.d/localdev.conf``` to specify the IP address for 
    the local https testing domain e.g.
    ```address=/localdev1.testproxy.devserver3.ustadmobile.com/192.168.1.5```
  * Restart dnsmasq ```sudo systemctl restart dnsmasq```
  * Test it: running ```dig @192.168.1.5 google.com``` should resolve as usual. Running 
    ```dig @192.168.1.5 localdev1.testproxy.devserver3.ustadmobile.com``` should return the IP
    address 192.168.1.5
  * On the Android device: go to WiFi settings, change IP settings from DHCP to static, and set the
    DNS address to 192.168.1.5 .
Android's verification of assetlinks.json includes the use of Google's cache - so using any 
self-signed certificate is not possible.


