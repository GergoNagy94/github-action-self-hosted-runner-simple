#!/bin/bash

sudo yum update -y

sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

sudo yum install -y libicu jq unzip

sudo su - ec2-user
sudo mkdir -p /home/ec2-user/actions-runner
cd /home/ec2-user/actions-runner || exit 1

RUNNER_VERSION="2.325.0"
sudo curl -o actions-runner-linux-x64-$RUNNER_VERSION.tar.gz -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
sudo tar xzf actions-runner-linux-x64-$RUNNER_VERSION.tar.gz

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo rm -rf aws awscliv2.zip

sudo chown -R ec2-user:ec2-user /home/ec2-user/actions-runner

sudo tee register_runner.sh >/dev/null <<'EOF'
#!/bin/bash
GITHUB_TOKEN=${github_token}
GITHUB_OWNER=${github_owner}
GITHUB_REPO=${github_repo}
RUNNER_NAME=${runner_name}

REGISTRATION_TOKEN=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_OWNER/$GITHUB_REPO/actions/runners/registration-token" | jq -r .token)

./config.sh --url "https://github.com/$GITHUB_OWNER/$GITHUB_REPO" \
  --token "$REGISTRATION_TOKEN" \
  --name "$RUNNER_NAME" \
  --work "_work" \
  --unattended \
  --replace

sudo ./svc.sh install ec2-user
sudo ./svc.sh start
EOF

sudo chmod +x register_runner.sh

./register_runner.sh

