#!/bin/bash

cat <<EOF
################################################################################

Welcome to the ghcr.io/servercontainers/rsync

################################################################################

You'll find this container sourcecode here:

    https://github.com/ServerContainers/rsync

The container repository will be updated regularly.

################################################################################


EOF

INITALIZED="/.initialized"

if [ ! -f "$INITALIZED" ]; then
  echo ">> CONTAINER: starting initialisation"

  ##
  # rsyncd secrets ENVs
  ##
  for I_CONF in "$(env | grep '^RSYNC_SECRET_')"
  do
    ACCOUNT_NAME=$(echo "$I_CONF" | cut -d'=' -f1 | sed 's/HTACCESS_ACCOUNT_//g' | tr '[:upper:]' '[:lower:]')
    CONF_CONF_VALUE=$(echo "$I_CONF" | sed 's/^[^=]*=//g')

    echo ">> RSYNC SECRETS: adding account: $ACCOUNT_NAME"
    echo "$CONF_CONF_VALUE" >> /etc/rsyncd.secrets

    unset $(echo "$I_CONF" | cut -d'=' -f1)
  done

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
