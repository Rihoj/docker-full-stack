#!/bin/sh
for file in /etc/nginx/conf.d.templates/*; do
    filename=`echo $file | awk -F"/" '{print $NF}'`;
    envsubst "`env | awk -F = '{printf \" $$%s\", $$1}'`" < /etc/nginx/conf.d.templates/$filename > /etc/nginx/conf.d/$filename;
done;
nginx -g 'daemon off;'
