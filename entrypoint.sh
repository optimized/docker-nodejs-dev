#!/bin/bash
# Add local user
# Either use the CURRENT_UID if passed in at runtime or
USER_ID=${CURRENT_UID:-9001}
echo "Starting with UID: $USER_ID"
echo "export CURRENT_UID=\$(id -u)"
usermod --shell /bin/bash -u $USER_ID -m node -d /home/node
export HOME=/home/node
chown -Rf $(id -u $USER_ID) /usr/src/app/ /usr/src/app/* /usr/src/app/.*
exec "$@"
