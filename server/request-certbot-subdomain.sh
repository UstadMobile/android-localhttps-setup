#!/bin/bash

certbot certonly  --email $EMAIL --agree-tos -d "localdev.$DOMAIN"
