#!/bin/bash

NGINX_DEB_VERSION=`curl -s https://nginx.org/packages/mainline/debian/pool/nginx/n/nginx/ |grep '"nginx_' | sed -n "s/^.*\">nginx_\(.*\)\~.*$/\1/p" |sort -Vr |head -1| cut -d'-' -f1`
DAV_VERSION=`curl -s https://api.github.com/repos/arut/nginx-dav-ext-module/tags |grep "name" |head -1 |sed -n "s/^.*v\(.*\)\".*$/\1/p"`

docker build --pull -t deb-dch -f Dockerfile-deb-dch .
docker run -it -v $PWD:/local -e HOME=/local deb-dch bash -c "cd /local && \
    dch -M -v ${DAV_VERSION}+nginx-${NGINX_DEB_VERSION}~stretch --distribution 'stretch' 'Updated upstream.'"

git add debian/changelog
git commit -m "Updated upstream."
git tag "webdav-ext-${DAV_VERSION}/nginx-${NGINX_DEB_VERSION}"
git push origin --tags
#git push origin "webdav-ext-${DAV_VERSION}/nginx-${NGINX_DEB_VERSION}"
