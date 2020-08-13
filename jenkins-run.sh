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
jenkins/jenkins:lts
echo;

#-----------------------------------------------------------------------------#
### Install vim

docker exec -u root jenkins-node bash -c "
apt update && apt install vim tree htop sudo -y;
apt-get update;
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y;
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -;
apt-get update;
apt-get install docker-ce docker-ce-cli containerd.io -y;
cat "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
usermod -aG docker jenkins
"

#-----------------------------------------------------------------------------#
echo;

echo "Please Copy the following line into localhost:8080"
echo;

cat secrets/initialAdminPassword
