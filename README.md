
Dockerfiles for building libnginx-mod-http-dav-ext for Debian / Ubuntu

[![packagecloud deb packages](https://img.shields.io/badge/deb-packagecloud.io-844fec.svg)](https://packagecloud.io/DaryL/libnginx-mod-http-dav-ext-stable) [![Build and Deploy](https://github.com/darylounet/libnginx-mod-http-dav-ext/actions/workflows/github-actions.yml/badge.svg)](https://github.com/darylounet/libnginx-mod-http-dav-ext/actions/workflows/github-actions.yml)

If you're just interested in installing built packages, go there :
https://packagecloud.io/DaryL/libnginx-mod-http-dav-ext-stable

/!\ Warning : these packages only works with official NGiNX Ubuntu / Debian repository : https://nginx.org/en/linux_packages.html#distributions

Instructions : https://packagecloud.io/DaryL/libnginx-mod-http-dav-ext-stable/install#manual-deb

If you're interested in installing [mainline](https://packagecloud.io/DaryL/libnginx-mod-http-dav-ext-mainline) NGiNX packages, go there :
https://packagecloud.io/DaryL/libnginx-mod-http-dav-ext-mainline

If you want to build packages by yourself, this is for you :

DCH Dockerfile usage (always use bullseye as it is replaced before build) :

```bash
docker build -t deb-dch -f Dockerfile-deb-dch .
docker run -it -v $PWD:/local -e HOME=/local deb-dch bash -c 'cd /local && \
dch -M -v 3.0.0+nginx-1.20.2-1~bullseye --distribution "bullseye" "Updated upstream."'
```

Build Dockerfile usage :

```bash
docker build -t build-nginx-webdav -f Dockerfile-deb \
--build-arg DISTRIB=debian --build-arg RELEASE=bullseye \
--build-arg NGINX_VERSION=1.18.0 --build-arg DAV_VERSION=3.0.0 .
```

Or for Ubuntu :
```bash
docker build -t build-nginx-webdav -f Dockerfile-deb \
--build-arg DISTRIB=ubuntu --build-arg RELEASE=bionic \
--build-arg NGINX_VERSION=1.18.0 --build-arg DAV_VERSION=3.0.0 .
```

Then :
```bash
docker run build-nginx-webdav
docker cp $(docker ps -l -q):/src ~/Downloads/
```

And once you don't need it anymore :
```bash
docker rm $(docker ps -l -q)
```

Get latest nginx-dav-ext-module version : https://github.com/arut/nginx-dav-ext-module/releases
Or :
```bash
curl -s https://api.github.com/repos/arut/nginx-dav-ext-module/tags |grep "name" |head -1 |sed -n "s/^.*v\(.*\)\".*$/\1/p"
```

Get latest nginx version : https://nginx.org/en/download.html
Or :
```bash
curl -s https://nginx.org/packages/debian/pool/nginx/n/nginx/ |grep '"nginx_' | sed -n "s/^.*\">nginx_\(.*\)\~.*$/\1/p" |sort -Vr |head -1| cut -d'-' -f1
```
