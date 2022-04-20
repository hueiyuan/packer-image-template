#!/bin/bash
set -euo pipefail

sleep 30
sudo apt update
sudo apt install -y awscli

echo $EXTERNAL_VARS
