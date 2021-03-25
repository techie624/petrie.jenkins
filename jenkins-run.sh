#!/usr/bin/env bash
#-----------------------------------------------------------------------------#
### Tagging images
# This script will pull retag and push all images within the EBS operating 
# environment

#-----------------------------------------------------------------------------#
#@author: RLPetrie (rlp243@cornell.edu)

#-----------------------------------------------------------------------------#
### verify proper arguments are passed

if [ $# -lt 3 ];
  then
    echo "No arguments supplied."
    echo "Usage: bash <bash_script_name>.sh <NDD_PARENT_PATH> <JENKINS_EXT_PORT> <IMAGE_TAG>"
    echo "/data directory is mounted which is normally a symlink which needs 
    to be mounted for the symlink pointer"
    exit 1
fi

#-----------------------------------------------------------------------------#
### set present working directory (jenkins repo) as jenkins_home

pwd="`pwd`" && echo $pwd

#-----------------------------------------------------------------------------#

NDD_PARENT_PATH=$1 # if NDD_PATH=/storage/persistent_data this should equal /storage
JENKINS_EXT_PORT=$2
IMAGE_TAG=$3

#-----------------------------------------------------------------------------#

#docker rm -f jenkins-node || true

#-----------------------------------------------------------------------------#

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
gadm01/gobii_jenkins:$IMAGE_TAG
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
