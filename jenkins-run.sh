#!/usr/bin/env bash
#-----------------------------------------------------------------------------#
### Tagging images
# This script will pull retag and push all images within the EBS operating 
# environment

#-----------------------------------------------------------------------------#
#@author: RLPetrie (rlp243@cornell.edu)

pwd="`pwd`" && echo $pwd

#-----------------------------------------------------------------------------#

docker stop jenkins-node || true && docker rm jenkins-node || true

#-----------------------------------------------------------------------------#

docker run -dti \
--name jenkins-node \
-h jenkins-node \
-v $pwd:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-p 8090:8080 \
-p 50000:50000 \
techie624/petrie.jenkins:v0.1
echo;

#-----------------------------------------------------------------------------#
### Install vim

docker exec -u root jenkins-node bash -c "
apt update && apt install vim tree htop sudo -y;
"
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