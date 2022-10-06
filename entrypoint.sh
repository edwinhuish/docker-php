#!/bin/sh
set -e

: ${USERNAME:=www}
export USERNAME
: GROUPNAME="$(id -gn $USERNAME)"
export GROUPNAME

: ${USER_UID:=1000}
export USER_UID
: ${USER_GID:=1000}
export USER_GID

: ${APACHE_RUN_USER:=$USERNAME}
export APACHE_RUN_USER
: ${APACHE_RUN_GROUP:=$GROUPNAME}
export APACHE_RUN_GROUP

usermod -u $USER_UID $USERNAME
groupmod -g $USER_GID $GROUPNAME

if [ -d /entrypoint.d ]; then
  for i in /entrypoint.d/*.sh; do
    if [ -r $i ]; then
      /bin/sh $i
    fi
  done
  unset i
fi

exec "$@"
