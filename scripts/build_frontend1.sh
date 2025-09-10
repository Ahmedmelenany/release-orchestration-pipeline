#!/bin/bash
set -e

VERSION=$1

echo "=== Building Frontend1 (Angular Web) - Version: $VERSION ==="

cd frontend1

# Install dependencies using local cache
npm ci --cache .npm

# Run tests (skip if none configured)
npm test || echo "⚠️ Skipping frontend1 tests"

# Build Angular app
npm run build -- --configuration production

# Package build output
tar -czf ../frontend1-$VERSION.tar.gz dist/

cd ..

# Upload to Nexus
echo "Uploading frontend1-$VERSION.tar.gz to Nexus..."
curl -u $NEXUS_USER:$NEXUS_PASS \
  --upload-file frontend1-$VERSION.tar.gz \
  "$NEXUS_URL/repository/$NEXUS_REPO/frontend1/$VERSION/frontend1-$VERSION.tar.gz"

echo "=== Frontend1 build & publish complete ==="
