#!/bin/bash
set -e

ENV=$1
VERSION=$2

echo "=== Deploying Frontend2 (Angular Admin) - Version: $VERSION to $ENV ==="

DEPLOY_DIR="/var/www/frontend2/$ENV"

# Download artifact from Nexus
curl -u $NEXUS_USER:$NEXUS_PASS \
  -o frontend2-$VERSION.tar.gz \
  "$NEXUS_URL/repository/$NEXUS_REPO/frontend2/$VERSION/frontend2-$VERSION.tar.gz"

# Clean old deployment and extract new one
sudo rm -rf $DEPLOY_DIR
sudo mkdir -p $DEPLOY_DIR
sudo tar -xzf frontend2-$VERSION.tar.gz -C $DEPLOY_DIR

echo "=== Frontend2 deployed to $ENV ==="
