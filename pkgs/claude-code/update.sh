#!/usr/bin/env nix-shell
#!nix-shell -i bash --packages nodejs nix-update git

# Derived from nixpkgs: Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors
# See COPYING-NIXPKGS for license details.
# Original: https://github.com/NixOS/nixpkgs/blob/4d256032cc83a2eccc3d366f596a7bf69c87f62d/pkgs/by-name/cl/claude-code/update.sh

set -euo pipefail

version=$(npm view @anthropic-ai/claude-code version)

# Update version and hash
AUTHORIZED=1 NIXPKGS_ALLOW_UNFREE=1 nix-update claude-code --version="$version" --generate-lockfile --print-commit-message

# Update npmDepsHash
AUTHORIZED=1 NIXPKGS_ALLOW_UNFREE=1 nix-update claude-code --version=skip
