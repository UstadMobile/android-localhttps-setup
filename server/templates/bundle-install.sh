#!/bin/bash

if [ ! -e /etc/letsencrypt/live/DOMAIN ]; then
   mkdir -p /etc/letsencrypt/live/DOMAIN
fi

cp fullchain.pem /etc/letsencrypt/live/DOMAIN/fullchain.pem
cp privkey.pem /etc/letsencrypt/live/DOMAIN/privkey.pem

if [ ! -e /etc/letsencrypt/options-ssl-apache.conf ]; then
   cp options-ssl-apache.conf /etc/letsencrypt/options-ssl-apache.conf/etc/letsencrypt/options-ssl-apache.conf
fi

cp 002-localhttps-DOMAIN.conf /etc/apache2/sites-available/
a2ensite 002-localhttps-DOMAIN.conf


