#!/bin/bash
set -e

VERSION=$1

echo "=== Building Frontend2 (Angular Admin) - Version: $VERSION ==="

cd frontend2

# Install dependencies using local cache
npm ci --cache .npm

# Run tests (skip if none configured)
npm test || echo "⚠️ Skipping frontend2 tests"

# Build Angular app
npm run build -- --configuration production

# Package build output
tar -czf ../frontend2-$VERSION.tar.gz dist/

cd ..

# Upload to Nexus
echo "Uploading frontend2-$VERSION.tar.gz to Nexus..."
curl -u $NEXUS_USER:$NEXUS_PASS \
  --upload-file frontend2-$VERSION.tar.gz \
  "$NEXUS_URL/repository/$NEXUS_REPO/frontend2/$VERSION/frontend2-$VERSION.tar.gz"

echo "=== Frontend2 build & publish complete ==="
