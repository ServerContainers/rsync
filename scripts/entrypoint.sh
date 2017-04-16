#!/bin/sh

cat <<EOF
################################################################################

Welcome to the servercontainers/rsync

################################################################################

EOF

INITALIZED="/.initialized"

if [ ! -f "$INITALIZED" ]; then
  echo ">> CONTAINER: starting initialisation"

  ##
  # rsyncd Global Config ENVs
  ##
  for I_CONF in "$(env | grep '^RSYNC_GLOBAL_CONFIG_')"
  do
    CONF_CONF_VALUE=$(echo "$I_CONF" | sed 's/^[^=]*=//g')

    echo "$CONF_CONF_VALUE" >> /etc/rsyncd.conf
  done
  echo "" >> /etc/rsyncd.conf

  ##
  # rsyncd Volume Config ENVs
  ##
  for I_CONF in "$(env | grep '^RSYNC_VOLUME_CONFIG_')"
  do
    CONF_CONF_VALUE=$(echo "$I_CONF" | sed 's/^[^=]*=//g')

    echo "$CONF_CONF_VALUE" | sed 's/;/\n/g' >> /etc/rsyncd.conf
    echo "" >> /etc/rsyncd.conf
  done

  touch "$INITALIZED"
else
  echo ">> CONTAINER: already initialized - direct start of rsync"
fi

##
# CMD
##
echo ">> CMD: exec docker CMD"
echo "$@"
exec "$@"
