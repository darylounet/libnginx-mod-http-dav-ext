#!/bin/bash

NGINX_DEB_VERSION=`curl -s https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/ |grep '"nginx_' | sed -n "s/^.*\">nginx_\(.*\)\~.*$/\1/p" |sort -Vr |head -1`
NGINX_VERSION=`echo ${NGINX_DEB_VERSION} | cut -d'-' -f1`
NGINX_DEB_RELEASE=`echo ${NGINX_DEB_VERSION} | cut -d'-' -f2`
DAV_VERSION=`curl -s https://api.github.com/repos/arut/nginx-dav-ext-module/tags |grep "name" |head -1 |sed -n "s/^.*v\(.*\)\".*$/\1/p"`

docker build -t build-nginx-webdav -f Dockerfile-deb \
	--build-arg DISTRIB=${OS} --build-arg RELEASE=${DIST} \
    --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg NGINX_DEB_RELEASE=${NGINX_DEB_RELEASE} \
    --build-arg DAV_VERSION=${DAV_VERSION} .
