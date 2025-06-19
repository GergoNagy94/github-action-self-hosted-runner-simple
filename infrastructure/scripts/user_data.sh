#!/bin/bash

yum update -y

yum install -y git curl jq docker

systemctl start docker
systemctl enable docker

useradd -m github-runner
usermod -aG docker github-runner

cd /home/github-runner

RUNNER_VERSION="2.311.0"
curl -o actions-runner-linux-x64-$RUNNER_VERSION.tar.gz -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz

tar xzf ./actions-runner-linux-x64-$RUNNER_VERSION.tar.gz

chown -R github-runner:github-runner /home/github-runner

cat > /home/github-runner/register_runner.sh << 'EOF'
#!/bin/bash

GITHUB_TOKEN="${github_token}"
GITHUB_OWNER="${github_owner}"
GITHUB_REPO="${github_repo}"
RUNNER_NAME="${runner_name}"

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

sudo ./svc.sh install github-runner
sudo ./svc.sh start
EOF

chmod +x /home/github-runner/register_runner.sh
chown github-runner:github-runner /home/github-runner/register_runner.sh

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

sudo -u github-runner bash -c "cd /home/github-runner && ./register_runner.sh"

yum install -y python3 python3-pip nodejs npm

echo "GitHub Runner setup completed at $(date)" >> /var/log/github-runner-setup.log