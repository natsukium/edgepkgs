#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#cacert nixpkgs#curl nixpkgs#bash nixpkgs#gnused --command bash

# Derived from nixpkgs: Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors
# See COPYING-NIXPKGS for license details.
# Original: https://github.com/NixOS/nixpkgs/blob/710be23bf524d4a0810c07cc087b1438bba65561/pkgs/by-name/cl/claude-code-bin/update.sh

set -euo pipefail

BASE_URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"

OLD_VERSION=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' pkgs/claude-code-bin/manifest.json)

VERSION=$(curl -fsSL "$BASE_URL/latest")

curl -fsSL "$BASE_URL/$VERSION/manifest.json" --output pkgs/claude-code-bin/manifest.json

echo "claude-code-bin: $OLD_VERSION -> $VERSION"
echo "Changelog: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md"
