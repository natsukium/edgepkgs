{
  pkgs ? import <nixpkgs> { },
}:
rec {
  claude-code = pkgs.callPackage ./pkgs/claude-code { };
  claude-code-bin = claude-code; # Added 2025-07-10: renamed to claude-code
  github-copilot-cli = pkgs.callPackage ./pkgs/github-copilot-cli { };
}
