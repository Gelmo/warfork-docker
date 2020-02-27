#!/bin/bash

set -e

set -x

shopt -s extglob

SERVER_INSTALLED_LOCK_FILE=/home/warfork/server/installed.lock
WF_CUSTOM_CONFIGS_DIR="${WF_CUSTOM_CONFIGS_DIR-/var/wf}"

installServer() {
  echo '> Installing server ...'

  /home/warfork/Steam/steamcmd.sh \
    +login anonymous \
    +force_install_dir /home/warfork/server \
    +app_update 1136510 validate \
    +quit

  echo '> Done'

  touch $SERVER_INSTALLED_LOCK_FILE

}

applyCustomConfigs() {
  echo "> Checking for custom configs at \"$WF_CUSTOM_CONFIGS_DIR\" ..."

  if [ -d "$WF_CUSTOM_CONFIGS_DIR" ]; then
      echo '> Found custom configs, applying ...'
      rsync -rti $WF_CUSTOM_CONFIGS_DIR/ /home/warfork/server/Warfork.app/Contents/Resources/basewf/
      echo '> Done'
  else
      echo '> No custom configs found to apply'
  fi
}

startServer() {
  echo '> Starting server ...'

  optionalParameters=""

  cd /home/warfork/server/Warfork.app/Contents/Resources/

  ./wftv_server.x86_64 \
      $optionalParameters \
      $WF_PARAMS

}

updateServer() {
  echo '> Checking for server update ...'

  /home/warfork/Steam/steamcmd.sh \
    +login anonymous \
    +force_install_dir /home/warfork/server \
    +app_update 1136510 \
    +quit

  echo '> Done'
}

if [ -f "$SERVER_INSTALLED_LOCK_FILE" ]; then
  updateServer
else
  installServer
fi

applyCustomConfigs

startServer