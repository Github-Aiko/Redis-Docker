#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Error:${plain} This script must be run as root user!\n" && exit 1

# Install the dependencies
if [ -f /etc/redhat-release ]; then
    yum install -y epel-release
    yum install -y update
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install docker-ce
    systemctl start docker
    systemctl enable docker


elif [ -f /etc/lsb-release ]; then
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt-get update
    apt-get install -y docker-ce
else
    echo -e "${red}Error:${plain} Your system is not supported to run it!\n" && exit 1
fi

# Install docker-compose
if [ ! -e "/usr/local/bin/docker-compose" ]; then
    echo -e "${green}Info:${plain} Installing docker-compose..."
    if [ -f /etc/redhat-release ]; then
        yum install -y epel-release
        yum install -y docker-compose
    elif [ -f /etc/lsb-release ]; then
        apt-get install -y docker-compose
    fi
else
    echo -e "${green}Info:${plain} docker-compose has been installed.\n"
fi

# clone Redis-Web-Manager
if [ ! -d "/www/wwwroot/Redis-Docker/docker-compose.yml" ]; then
    cd /www/wwwroot/
    git clone https://github.com/Github-Aiko/Redis-Docker.git
    cd Redis-Docker
    docker-compose up -d
else
    echo -e "${green}Info:${plain} Redis-Web-Manager has been installed.\n"
fi

# install success
echo -e "${green}Info:${plain} Redis-Web-Manager install success.\n"