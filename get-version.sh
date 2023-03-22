#!/bin/bash
export IMG=$(docker build -q --pull --no-cache -t 'get-version' .)

#export RSYNC_VERSION=$(cat Dockerfile | tr ' ' '\n' | grep "rsync_version=" | cut -d"=" -f2)
# auto update rsync
export RSYNC_VERSION=$(curl https://rsync.samba.org/ 2>/dev/null | grep h3 | grep Rsync | grep released | head -n1 | tr ' ' '\n' | grep '[0-9]\.[0-9]')
export FOOBAR=$(sed -i.bak 's/rsync_version=3.2.7/rsync_version='"$RSYNC_VERSION"'/g' Dockerfile; rm Dockerfile.bak)
export ALPINE_VERSION=$(docker run --rm -t get-version cat /etc/alpine-release | tail -n1 | tr -d '\r')
[ -z "$ALPINE_VERSION" ] && exit 1

export IMGTAG=$(echo "$1""a$ALPINE_VERSION-r$RSYNC_VERSION")
export IMAGE_EXISTS=$(docker pull "$IMGTAG" 2>/dev/null >/dev/null; echo $?)

# return latest, if container is already available :)
if [ "$IMAGE_EXISTS" -eq 0 ]; then
  echo "$1""latest"
else
  echo "$IMGTAG"
fi