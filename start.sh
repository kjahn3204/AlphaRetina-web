#!/bin/bash
REGISTRY=raondatak8s
PRJ_NAME=alpha-retina
APP_NAME=client
WORK_DIR=$(dirname $(realpath $0))  # get directory path of this shellscript file
BIND_IP=172.20.0.21
BIND_PORT="8080:80"

###################################### func definition ######################################

function log {
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  if [ $# == 1 ] ; then
    echo "[$timestamp] $SCRIPT_NAME >> $1"
  else
    echo "[$timestamp] $SCRIPT_NAME >>>> $1: $2"
  fi
}

function get_named_arguments {
  echo ">>> start.sh: 1. get named arguments"
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
      --tag=*)
      NEW_TAG="${arg#*=}"
      shift
      ;;
      --ip=*)
      BIND_IP="${arg#*=}"
      shift
      ;;
      --port=*)
      BIND_PORT="${arg#*=}"
      shift
      ;;
      --data-dir=*)
      DATA_DIR="${arg#*=}"
      shift
      ;;
    esac
  done

  REPO=${PRJ_NAME}-${APP_NAME}
}

function get_tag {
  local regname=$1
  local repo=$2
  local tag=""
  tag=$(docker images --format '{{.Repository}}\t{{.Tag}}' --filter=reference="${regname}/${repo}*" | sed 's/ //' | sort -k3 -t "." -n -r | column -t | head -n 1 | awk '{print $2}')
  if [ -z $tag ] || [ $tag == "" ] ; then
    tag=0.0.0
  fi
  echo "${tag}"
}

function run {
  echo ">>> start.sh: run new container..."
  docker run \
    -d \
    --name ${REPO} \
    --net alpharetina \
    --ip ${BIND_IP} \
    -p ${BIND_PORT} \
    ${IMG}
}

# 1. get named arguments
get_named_arguments $@

# 2. set vars
TAG=$(get_tag $REGISTRY $REPO)
IMG=${REGISTRY}/${REPO}:${TAG}

# 3. run
run
