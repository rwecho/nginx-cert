#!/bin/bash
# Run Script

# Create a self signed certificate, should the user need it
openssl req -subj "/C=$COUNTRY/" -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/default-server.key -out /etc/ssl/certs/default-server.crt

certbot --nginx --non-interactive --agree-tos -m $EMAIL --domains $DOMAINS

# Restart NGINX
/etc/init.d/nginx restart