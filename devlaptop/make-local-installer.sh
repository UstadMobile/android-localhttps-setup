#!/bin/bash

DOMAIN=$1
OUTDIR="out"


if [ "$DOMAIN" == "" ]; then
   echo "Specify a domain e.g. make-local-installer localdev.testproxy.devserver3.ustadmobile.com"
   exit 1
fi

if [ -e $OUTDIR ]; then
   rm -r $OUTDIR
fi

mkdir $OUTDIR


