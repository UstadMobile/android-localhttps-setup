#!/bin/bash
OUTPUT=$1

if [ "$OUTPUT" == "" ]; then
    echo args: output file
    exit 1
fi

if [ -e $OUTPUT ]; then
    rm $OUTPUT
fi

for port in {8070..8079}; do
    sed "s/PORTNUM/$port/g" testproxy-template.conf >> $OUTPUT
done

