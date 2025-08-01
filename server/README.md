# Server setup

For a given domain (e.g. testing.example.org):

* DNS: setup a wildcard entry ( *.testing.example.org) to point to the server's public IP address.  
* Setup an Apache HTTP server to run on the domain
* Update templates/assetlinks.json to include the SHA-256 fingerprint as per [official docs](https://developer.android.com/training/app-links#manage-verify)
    * If required get the SHA-256 signature for a debug APK as follows
```
$ ~/Android/Sdk/build-tools/33.0.1/apksigner verify --print-certs ./build/outputs/apk/debug/app-android-debug.apk
# Convert SHA-256 into : separated version
$ echo (sha256 from apksigner verify) | sed 's/../&:/g; s/:$//' | tr [:lower:] [:upper:]
```
* Request a wildcard https certificate using certbot:

```
$ export DOMAIN=testing.example.org
$ export EMAIL=info@example.org
$ ./request-certbot-wildcard.sh
```

* Copy assetlinks.json to the HTTP directory such that it can be loaded from ```https://testing.example.org/.well-known/assetlinks.json```
* Add an Apache virtual host for testing.example.org :

```
$ export DOMAIN=testing.example.org
$ sed "s/DOMAIN/$DOMAIN/g" templates/001-testing-root.conf > /etc/apache2/sites-available/001-testing-$DOMAIN-root.conf
$ a2ensite 001-testing-$DOMAIN-root.conf
$ systemctl apache2 restart
```

* Test that ```https://testing.example.org/.well-known/assetlinks.json``` loads over https as expected in a browser

## Generate bundle for running https locally

Request a certificate for a localdev subdomain that will run locally (e.g. localdev.testing.example.org):
```
$ export DOMAIN=testing.example.org
$ export EMAIL=info@example.org
$ ./request-certbot-subdomain.sh
```

Generate a bundle that can then be installed on a developer laptop:
```
export DOMAIN=testing.example.org
$ ./make-subdomain-bundle.sh
```
This generates a .zip to be copied to the developer's laptop containing the https certificate, key, Apache config and a 
simple .sh install script.


## Continuous integration server setup

This Apache setup allows a backend server for continuous integration running on a specific port (e.g. 8070) to
be accessed over https such that ```https://8070.testing.example.org``` is proxied by Apache to http://localhost:8070/ .

A script can be used to generate virtual hosts for a range of ports (e.g. ten or so) such that a single server can
run tests in parallel.

e.g. to generate configuration for 10 virtual hosts from 8070 until 8079:
```
./make-testproxy-conf.sh 8070 8079
```




