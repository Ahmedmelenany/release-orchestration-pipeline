#!/bin/bash
set -e

VERSION=$1

echo "=== Building Backend (.NET API) - Version: $VERSION ==="

cd backend

# Restore dependencies into local ./packages folder
dotnet restore --packages ./packages

# Build
dotnet build -c Release

# Run tests
dotnet test --no-build --verbosity normal

# Publish
dotnet publish -c Release -o out

# Package as zip
cd out
zip -r ../../backend-$VERSION.zip .
cd ../..

# Upload to Nexus
echo "Uploading backend-$VERSION.zip to Nexus..."
curl -u $NEXUS_USER:$NEXUS_PASS \
  --upload-file backend-$VERSION.zip \
  "$NEXUS_URL/repository/$NEXUS_REPO/backend/$VERSION/backend-$VERSION.zip"

echo "=== Backend build & publish complete ==="
