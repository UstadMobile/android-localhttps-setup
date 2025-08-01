# Android HTTPS local development scripts

HTTPS is required for (and thus to fully test):

* [App links](https://developer.android.com/training/app-links/verify-android-applinks)
* [Passkeys](https://developer.android.com/identity/sign-in/credential-manager#create-passkey)

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

**To use**:

* First setup the [server](server/)
* Then setup [developer's laptop](devlaptop/)



