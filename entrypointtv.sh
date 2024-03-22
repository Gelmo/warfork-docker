#!/bin/bash

set -e

if [ "${DEBUG}" = "true" ]; then
  set -x
fi

shopt -s extglob

steam_dir="${HOME}/Steam"
server_dir="${HOME}/server"
server_installed_lock_file="${server_dir}/installed.lock"
wf_dir="${server_dir}/Warfork.app/Contents/Resources/basewf"
wf_custom_configs_dir="${WF_CUSTOM_CONFIGS_DIR-"/var/wf"}"

install() {
  echo '> Installing server ...'

  set -x

  $steam_dir/steamcmd.sh \
    +force_install_dir $server_dir \
    +login anonymous \
    +app_update 1136510 validate \
    +quit

  set +x

  echo '> Done'

  touch $server_installed_lock_file
}

sync_custom_files() {
  echo "> Checking for custom files at \"$wf_custom_configs_dir\" ..."

  if [ -d "$wf_custom_configs_dir" ]; then
    echo "> Found custom files. Syncing with \"${wf_dir}\" ..."

    set -x

    cp -asf $wf_custom_configs_dir/* $wf_dir # Copy custom files as soft links
    find $wf_dir -xtype l -delete            # Find and delete broken soft links

    set +x

    echo '> Done'
  else
    echo '> No custom files found'
  fi
}

start() {
  echo '> Starting server ...'

  optionalParameters=""

  cd $wf_dir/..

  set -x

  exec ./wftv_server.x86_64 \
      $optionalParameters \
      $WF_PARAMS
}

update() {
  if [ "${VALIDATE_SERVER_FILES-"false"}" = "true" ]; then
    echo '> Validating server files and checking for server update ...'
  else
    echo '> Checking for server update ...'
  fi

  if [ "${VALIDATE_SERVER_FILES-"false"}" = "true" ]; then
    set -x

    $steam_dir/steamcmd.sh \
      +force_install_dir $server_dir \
      +login anonymous \
      +app_update 1136510 validate \
      +quit

    set +x
  else
    set -x

    $steam_dir/steamcmd.sh \
      +force_install_dir $server_dir \
      +login anonymous \
      +app_update 1136510 \
      +quit

    set +x
  fi

  echo '> Done'
}

install_or_update() {
  if [ -f "$server_installed_lock_file" ]; then
    update
  else
    install
  fi
}

if [ ! -z $1 ]; then
  $1
else
  install_or_update
  sync_custom_files
  start
fi