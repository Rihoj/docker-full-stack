#!/bin/sh
apt update;
apt install gettext -y --force-yes;
envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" < conf/config.template.json > conf/config.json;
bash -c /app/dns-proxy-server
