#!/bin/bash
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

sudo yum install -y --allowerasing curl unzip jq libicu

if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

mkdir -p /home/ec2-user/actions-runner && cd /home/ec2-user/actions-runner
curl -o actions-runner-linux-x64-2.325.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-linux-x64-2.325.0.tar.gz
echo "5020da7139d85c776059f351e0de8fdec753affc9c558e892472d43ebeb518f4  actions-runner-linux-x64-2.325.0.tar.gz" | shasum -a 256 -c
tar xzf actions-runner-linux-x64-2.325.0.tar.gz
chown -R ec2-user:ec2-user /home/ec2-user/actions-runner

sudo su - ec2-user -c "cd ~/actions-runner && ./config.sh --url ${repo_url} --token ${github_token} --labels self-hosted,aws-runner --name github-runner --unattended"
sudo su - ec2-user -c "cd ~/actions-runner && ./run.sh &"

sudo chmod 644 /var/log/amazon/ssm/amazon-ssm-agent.log