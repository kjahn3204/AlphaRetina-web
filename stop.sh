#!/bin/bash
PRJ_NAME=alpha-retina
APP_NAME=client
REPO=''

function get_named_arguments {
  echo ">>> build.sh: 1. get named arguments"
  for arg in "$1"
  do
    case $arg in
      --prj=*)
      PRJ_NAME="${arg#*=}"
      shift
      ;;
      --app=*)
      APP_NAME="${arg#*=}"
      shift
      ;;
    esac
  done

  REPO=${PRJ_NAME}-${APP_NAME}
}

function stop {
  container_name=$1
  docker stop $container_name || true
  docker rm $container_name || true
}

# 1. named arguments
get_named_arguments $@

# 2.
stop $REPO

