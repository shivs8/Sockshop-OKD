#!/bin/bash -e
apt-get update
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common socat unzip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Install docker
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io
usermod -aG docker azureuser

# Install docker: prepare for OpenShift
sed -i 's/ExecStart=\(.*\)/ExecStart=\1 --insecure-registry 172.30.0.0\/16/' /lib/systemd/system/docker.service
sed -i 's/SocketMode=\(.*\)/SocketMode=0666/' /lib/systemd/system/docker.socket
systemctl daemon-reload
systemctl restart docker

# Install oc CLI
cd ~
  wget -q -O oc-linux.tar.gz https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
  tar xvzf oc-linux.tar.gz
  mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc .

chown root:root oc
mv oc /usr/bin
