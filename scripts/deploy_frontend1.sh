#!/bin/bash
set -e

ENV=$1
VERSION=$2

echo "=== Deploying Frontend1 (Angular Web) - Version: $VERSION to $ENV ==="

DEPLOY_DIR="/var/www/frontend1/$ENV"

# Download artifact from Nexus
curl -u $NEXUS_USER:$NEXUS_PASS \
  -o frontend1-$VERSION.tar.gz \
  "$NEXUS_URL/repository/$NEXUS_REPO/frontend1/$VERSION/frontend1-$VERSION.tar.gz"

# Clean old deployment and extract new one
sudo rm -rf $DEPLOY_DIR
sudo mkdir -p $DEPLOY_DIR
sudo tar -xzf frontend1-$VERSION.tar.gz -C $DEPLOY_DIR

echo "=== Frontend1 deployed to $ENV ==="
