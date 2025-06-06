#!/bin/bash
sudo yum update -y
sudo yum install -y docker awscli
sudo systemctl enable docker
sudo systemctl start docker

mkdir /actions-runner && cd /actions-runner || exit
curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz

sudo ./config.sh --url ${repo_url} --token ${github_token} --name "aws-runner-$(hostname)" --work _work --labels aws-runner --unattended

sudo ./svc.sh install
sudo ./svc.sh start