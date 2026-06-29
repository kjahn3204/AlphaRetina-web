#!/bin/bash
REGISTRY=raondatak8s
PRJ_NAME=alpha-retina
APP_NAME=client
DEPLOY_MODE=prod
WORK_DIR=$(dirname $(realpath $0))  # get directory path of this shellscript file
PREBUILD=yes

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
      --deploy-mode=*)
      DEPLOY_MODE="${arg#*=}"
      shift
      ;;
      --prebuild=*)
      PREBUILD="${arg#*=}"
      shift
      ;;
      --tag=*)
      NEW_TAG="${arg#*=}"
      shift
      ;;
    esac
  done

  if [ "$DEPLOY_MODE" != "dev" ] && [ "$DEPLOY_MODE" != "prod" ] ; then
    echo "argument error: 'deploy-mode' is not valid (deploy-mode: $DEPLOY_MODE)"
  fi
  if [ "$DEPLOY_MODE" == "dev" ] ; then
    GIT_BRANCH=dev
  elif [ "$DEPLOY_MODE" == "prod" ] ; then
    GIT_BRANCH=main
  fi

  REPO=${PRJ_NAME}-${APP_NAME}
}

function update_src {
  git checkout ${GIT_BRANCH}
  git pull
}

function increase_version {
  local tag=$1
  local incremented_last_part=$(($(echo $tag | awk -F. '{print $NF}') + 1))
  echo $(echo $tag | sed "s/\(.*\)\.\(.*\)/\1.${incremented_last_part}/")
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

function set_tag {
  local old_tag=$(get_tag $REGISTRY $REPO)
  local new_tag=$NEW_TAG
  
  if [ -z "$new_tag" ] ; then  # -z: empty , -n: has value
    new_tag=$(increase_version $old_tag)
    if [ -z $new_tag ] || [ $new_tag == "" ] ; then
      new_tag=0.0.0
    fi
    NEW_TAG="${new_tag}"
  fi
  log set_tag "old_tag=$old_tag, new_tag=$new_tag"
  
  IMG=${REGISTRY}/${REPO}:${NEW_TAG}
  log set_tag "IMG=$IMG"
}

function prebuild {
  yarn
  yarn build
}

function build {
  docker build \
    -t ${IMG} \
    -f ${WORK_DIR}/docker/${DEPLOY_MODE}.Dockerfile ${WORK_DIR} \
    --build-arg VERSION=${TAG} \
    --build-arg DEPLOY_MODE=${DEPLOY_MODE}
}

###################################### main process scripts ######################################
# 1. get named arguments
echo ""
log "1. get named arguments"
get_named_arguments $@

# 2. set tag
echo ""
log "2. set new tag"
set_tag

# 3. update source codes
echo ""
log "3. refresh source code with branch '$GIT_BRANCH'"
update_src

# 4. prebuild - yarn
echo ""
if [ $PREBUILD == "yes" ] ; then
  log "4. prebuild for $APP_NAME ..."
  prebuild
fi

# 5. build
echo ""
log "5. build image"
build
