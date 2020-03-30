#!/bin/bash

NGINX_VERSION=`curl -s https://nginx.org/packages/ubuntu/dists/bionic/nginx/binary-amd64/Packages.gz |zcat |php -r 'preg_match_all("#Package: nginx\nVersion: (.*?)-\d~.*?\nArch#", file_get_contents("php://stdin"), $m);echo implode($m[1], "\n")."\n";' |sort -r |head -1`
DAV_VERSION=`curl -s https://api.github.com/repos/arut/nginx-dav-ext-module/tags |grep "name" |head -1 |sed -n "s/^.*v\(.*\)\".*$/\1/p"`

docker build -t build-nginx-webdav -f Dockerfile-deb \
	--build-arg DISTRIB=${OS} --build-arg RELEASE=${DIST} \
    --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg DAV_VERSION=${DAV_VERSION} .
