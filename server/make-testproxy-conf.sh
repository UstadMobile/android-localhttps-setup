#!/bin/bash

FROMPORT=$1
TOPORT=$2

if [ "$OUTPUT" == "" ]; then
   OUTPUT=/etc/apache2/sites-available/testproxy-DOMAIN.conf
fi


if [ -e $OUTPUT ]; then
   rm $OUTPUT
fi

for port in $(seq $FROMPORT $TOPORT); do
    sed "s/PORTNUM/$port/g" templates/testproxy-virtualhost-template.conf >> $OUTPUT
done

sed -i "s/DOMAIN/$DOMAIN/g" $OUTPUT

