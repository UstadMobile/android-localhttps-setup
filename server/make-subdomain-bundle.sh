#!/bin/bash

OUTDIR=localhttps-$DOMAIN

if [ -e $OUTDIR ]; then
   rm -r $OUTDIR
fi

mkdir $OUTDIR
cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem $OUTDIR
cp /etc/letsencrypt/live/$DOMAIN/privkey.pem $OUTDIR
cp /etc/letsencrypt/options-ssl-apache.conf $OUTDIR
sed "s/DOMAIN/$DOMAIN/g" templates/002-localhttps.conf > $OUTDIR/002-localhttps-$DOMAIN.conf
sed "s/DOMAIN/$DOMAIN/g" templates/bundle-install.sh > $OUTDIR/install.sh

zip -r localhttps-$DOMAIN-bundle.zip $OUTDIR
