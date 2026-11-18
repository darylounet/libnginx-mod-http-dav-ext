#!/bin/bash

NGINX_DEB_VERSION=`curl -s https://nginx.org/packages/debian/pool/nginx/n/nginx/ |grep '"nginx_' | sed -n "s/^.*\">nginx_\(.*\)\~.*$/\1/p" |sort -Vr |head -1`
NGINX_VERSION=`echo ${NGINX_DEB_VERSION} | cut -d'-' -f1`
NGINX_DEB_RELEASE=`echo ${NGINX_DEB_VERSION} | cut -d'-' -f2`
# Latest stable tag, read with git rather than the GitHub API: the API is
# rate-limited (60 req/h per IP when unauthenticated), which silently returned
# an empty version on shared CI runners.
DAV_VERSION=`git ls-remote --tags --refs https://github.com/arut/nginx-dav-ext-module 'v*' |sed -n 's|^.*refs/tags/v\([0-9][0-9.]*\)$|\1|p' |sort -V |tail -1`

for var in NGINX_DEB_VERSION DAV_VERSION; do
    if [ -z "${!var}" ]; then
        echo "Error: could not determine ${var} (network failure or upstream format change)." >&2
        exit 1
    fi
done

docker build -t build-nginx-webdav -f Dockerfile-deb \
	--build-arg DISTRIB=${OS} --build-arg RELEASE=${DIST} \
    --build-arg NGINX_VERSION=${NGINX_VERSION} --build-arg NGINX_DEB_RELEASE=${NGINX_DEB_RELEASE} \
    --build-arg DAV_VERSION=${DAV_VERSION} .
