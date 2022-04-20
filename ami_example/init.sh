#!/bin/bash
set -euo pipefail

sleep 30
sudo apt update
sudo apt install -y awscli

echo $EXTERNAL_VARS

sudo mv /tmp/ami-example.service /etc/systemd/system/ami-example.service
sudo systemctl daemon-reload
