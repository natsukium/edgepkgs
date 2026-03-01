#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#bash nixpkgs#jq nixpkgs#nix --command bash

# Derived from nixpkgs: Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors
# See COPYING-NIXPKGS for license details.
# Original: https://github.com/NixOS/nixpkgs/blob/3c3cb6e32ae598deb18dbccf308c04be5c4e413f/pkgs/by-name/gi/github-copilot-cli/update.sh

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
SOURCES_FILE="$ROOT/sources.json"

OLD_VERSION=$(jq -r .version "$SOURCES_FILE")

LATEST_TAG=$(curl -s https://api.github.com/repos/github/copilot-cli/releases/latest | jq -r .tag_name)

if [ -z "$LATEST_TAG" ] || [ "$LATEST_TAG" = "null" ]; then
  echo "Failed to fetch latest release from GitHub API"
  exit 1
fi

VERSION="${LATEST_TAG#v}"

echo "Updating to version $VERSION"

# Create a temporary file for the JSON content
TMP_FILE=$(mktemp)

jq -n --arg v "$VERSION" '{version: $v}' > "$TMP_FILE"

process_platform() {
  local system="$1"
  local name="$2"
  local url="https://github.com/github/copilot-cli/releases/download/v${VERSION}/${name}.tar.gz"

  echo "Processing $system..."

  hash=$(nix-prefetch-url --type sha256 "$url")
  sri_hash=$(nix hash convert --to sri --hash-algo sha256 "$hash")

  jq --arg sys "$system" --arg n "$name" --arg h "$sri_hash" '. + {($sys): {name: $n, hash: $h}}' \
    "$TMP_FILE" > "${TMP_FILE}.tmp" && mv "${TMP_FILE}.tmp" "$TMP_FILE"
}

process_platform "x86_64-linux" "copilot-linux-x64"
process_platform "aarch64-linux" "copilot-linux-arm64"
process_platform "x86_64-darwin" "copilot-darwin-x64"
process_platform "aarch64-darwin" "copilot-darwin-arm64"

mv "$TMP_FILE" "$SOURCES_FILE"

echo "github-copilot-cli: $OLD_VERSION -> $VERSION"
echo "Changelog: https://github.com/github/copilot-cli/releases/tag/v$VERSION"
