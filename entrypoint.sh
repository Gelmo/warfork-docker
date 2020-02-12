#!/bin/bash

set -e

set -x

shopt -s extglob

STEAM_DIR=$HOME/Steam
SERVER_DIR=$HOME/server
SERVER_INSTALLED_LOCK_FILE=$SERVER_DIR/installed.lock
WF_DIR=$SERVER_DIR/Warfork.app/Contents/Resources/basewf
WF_CUSTOM_CONFIGS_DIR="${WF_CUSTOM_CONFIGS_DIR-/var/wf}"

installServer() {
  echo '> Installing server ...'

  $STEAM_DIR/steamcmd.sh \
    +login anonymous \
    +force_install_dir $SERVER_DIR \
    +app_update 671610 validate \
    +quit

  echo '> Done'

  touch $SERVER_INSTALLED_LOCK_FILE

}

applyCustomConfigs() {
  echo "> Checking for custom configs at \"$WF_CUSTOM_CONFIGS_DIR\" ..."

  if [ -d "$WF_CUSTOM_CONFIGS_DIR" ]; then
      echo '> Found custom configs, applying ...'
      rsync -ri $WF_CUSTOM_CONFIGS_DIR/ $WF_DIR
      echo '> Done'
  else
      echo '> No custom configs found to apply'
  fi
}

startServer() {
  echo '> Starting server ...'

  optionalParameters=""

  $SERVER_DIR/Warfork.app/Contents/Resources/wf_server.x86_64 \
      $optionalParameters \
      $WF_PARAMS

}

updateServer() {
  echo '> Checking for server update ...'

  $STEAM_DIR/steamcmd.sh \
    +login anonymous \
    +force_install_dir $HOME/server \
    +app_update 671610 \
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