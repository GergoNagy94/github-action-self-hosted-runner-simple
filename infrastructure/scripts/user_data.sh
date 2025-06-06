#!/bin/bash
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

sudo yum install -y curl unzip jq

if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

mkdir -p /home/ec2-user/actions-runner && cd /home/ec2-user/actions-runner
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz
tar xzf actions-runner-linux-x64.tar.gz
chown -R ec2-user:ec2-user /home/ec2-user/actions-runner

sudo su - ec2-user -c "cd ~/actions-runner && ./config.sh --url ${repo_url} --token ${github_token} --labels aws-runner --name github-runner"
sudo su - ec2-user -c "cd ~/actions-runner && ./run.sh &"

sudo chmod 644 /var/log/amazon/ssm/amazon-ssm-agent.log