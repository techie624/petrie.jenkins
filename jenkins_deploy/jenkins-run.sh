#!/usr/bin/env bash

#-----------------------------------------------------------------------------#
#@author: RLPetrie (rlp243@cornell.edu)

#-----------------------------------------------------------------------------#
### verify proper arguments are passed

if [ $# -lt 4 ];
  then
    echo "No arguments supplied."
    echo "Usage: bash <bash_script_name>.sh <NDD_PARENT_PATH> <JENKINS_EXT_PORT> <push_new_image_to_dockerhub=True/False> <branch> <DOCKERHUB_PASSWORD_(optional)>"
    echo "/data directory is mounted which is normally a symlink which needs 
    to be mounted for the symlink pointer"
    exit 1
fi

#--------------------------------------#

set -e # Abort script at first error
set -u # Attempt to use undefined variable outputs error message
#set -x # Verbose with commands displayed

#--------------------------------------#

NDD_PARENT_PATH=$1 # if NDD_PATH=/storage/persistent_data this should equal /storage
JENKINS_EXT_PORT=$2
PUSH_IMAGE=$3
BRANCH=$4

echo "$BRANCH"
BUILD_TAG="$BRANCH"_$(date +"%Y%m%d")
echo "BUILD_TAG is set as: $BUILD_TAG";
echo;

DOCKER_HUB_USERNAME="gdm01"
DOCKER_HUB_REPO_NAME="gobii_jenkins"

DOCKER_HUB_LOGIN_USERNAME="gadmreader"

set +u
if [[ -n "${5}" ]]; then DOCKER_HUB_PASSWORD="$5"; else echo "Docker Hub Password not passed into script via script arg. --> \$5"; fi
echo;
set -u

set -x

#--------------------------------------#
# Remove any jenkins/jenkins:latest images

docker rmi -f jenkins/jenkins:latest || true;

#--------------------------------------#
# running jenkins image build

time docker image build -t $DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME:$BUILD_TAG .

#--------------------------------------#
# Remove any jenkins/jenkins:latest images

docker rmi -f jenkins/jenkins:latest || true;

if [[ "$PUSH_IMAGE" = true ]]; then
  #--------------------------------------#
  # log into dockerhub
  set +x # Turning down verbosity as the password is echoed to stdout
  docker logout

  if [ $DOCKER_HUB_PASSWORD = "askme" ]; then
    read -sp "Please enter your docker hub user password for [$DOCKER_HUB_LOGIN_USERNAME]: " DOCKER_HUB_PASSWORD
  fi
  echo;

  docker login -u $DOCKER_HUB_LOGIN_USERNAME -p $DOCKER_HUB_PASSWORD
  set -x

  time docker push $DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME:$BUILD_TAG
else
  echo "Not pushing image to Docker hub."
  echo;
fi

#-----------------------------------------------------------------------------#
### set present working directory (jenkins repo) as jenkins_home

cd ..
pwd="`pwd`" && echo $pwd

#-----------------------------------------------------------------------------#
### Run Jenkins

docker run -dti \
--name jenkins-node \
-h jenkins-node \
-v ${NDD_PARENT_PATH}:${NDD_PARENT_PATH} \
-v /data:/data \
-v $pwd:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-p $JENKINS_EXT_PORT:8080 \
-p 50000:50000 \
--restart=always \
$DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME:$BUILD_TAG
echo;

#-----------------------------------------------------------------------------#
### On initial setup display initialAdminPassword

docker exec -u root jenkins-node bash -c '
FILE="/var/jenkins_home/secrets/initialAdminPassword"
if [[ -f "$FILE" ]]; then
   echo "Please Copy the following line into localhost:8080"
   cat /var/jenkins_home/secrets/initialAdminPassword
   echo;
fi';
echo;

#-----------------------------------------------------------------------------#
### Script completion

echo "Jenkins Deployment script has completed! Good Bye."
echo;
