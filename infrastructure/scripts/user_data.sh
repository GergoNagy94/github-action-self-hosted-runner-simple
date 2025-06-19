#!/bin/bash

yum update -y

sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

RUNNER_VERSION="2.325.0"
sudo mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-$RUNNER_VERSION.tar.gz -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz

sudo dnf install -y libicu
sudo dnf install -y dotnet-sdk-6.0

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