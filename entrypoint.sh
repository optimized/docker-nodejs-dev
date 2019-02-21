#!/bin/bash

# Add local user
# Either use the CURRENT_UID if passed in at runtime or
# fallback

USER_ID=${CURRENT_UID:-9001}

echo "Starting with UID: $USER_ID"
echo "export CURRENT_UID=\$(id -u)"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

chown -R $(id -u $USER_ID):$(id -g $USER_ID) /usr/src/app

