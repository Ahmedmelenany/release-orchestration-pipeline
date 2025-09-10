#!/bin/bash
set -e

ENV=$1
VERSION=$2

echo "=== Deploying Backend (.NET API) - Version: $VERSION to $ENV ==="

# Target deployment directory
DEPLOY_DIR="/opt/apps/backend/$ENV"

# Download artifact from Nexus
curl -u $NEXUS_USER:$NEXUS_PASS \
  -o backend-$VERSION.zip \
  "$NEXUS_URL/repository/$NEXUS_REPO/backend/$VERSION/backend-$VERSION.zip"

# Clean old deployment and extract new one
sudo rm -rf $DEPLOY_DIR
sudo mkdir -p $DEPLOY_DIR
sudo unzip -q backend-$VERSION.zip -d $DEPLOY_DIR

# Restart backend service (assuming systemd service called backend-api)
sudo systemctl restart backend-api

echo "=== Backend deployed to $ENV ==="
