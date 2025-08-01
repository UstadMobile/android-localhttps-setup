#!/bin/bash

OUTDIR=localhttps-$DOMAIN

#Local dev subdomain
SUBDOMAIN=localdev


if [ -e $OUTDIR ]; then
   rm -r $OUTDIR
fi

mkdir $OUTDIR
cp /etc/letsencrypt/live/$SUBDOMAIN.$DOMAIN/fullchain.pem $OUTDIR
cp /etc/letsencrypt/live/$SUBDOMAIN.$DOMAIN/privkey.pem $OUTDIR
cp /etc/letsencrypt/options-ssl-apache.conf $OUTDIR
sed "s/DOMAIN/$SUBDOMAIN.$DOMAIN/g" templates/002-localhttps.conf > $OUTDIR/002-localhttps-$SUBDOMAIN.$DOMAIN.conf
sed "s/DOMAIN/$SUBDOMAIN.$DOMAIN/g" templates/bundle-install.sh > $OUTDIR/install.sh

zip -r localhttps-$SUBDOMAIN.$DOMAIN-bundle.zip $OUTDIR
