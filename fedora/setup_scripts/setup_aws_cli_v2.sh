#!/usr/bin/env bash

echo "Installing AWS CLI v2"
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
complete -C aws_completer aws
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
dnf install -y session-manager-plugin.rpm
rm session-manager-plugin.rpm
rm awscliv2.zip
rm -r aws
