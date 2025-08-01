#!/bin/bash

certbot certonly --manual --preferred-challenge=dns --email $EMAIL --agree-tos -d "$DOMAIN" -d "*.$DOMAIN"
