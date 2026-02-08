{
  pkgs ? import <nixpkgs> { },
}:
{
  claude-code = pkgs.callPackage ./pkgs/claude-code { };
  claude-code-bin = pkgs.callPackage ./pkgs/claude-code-bin { };
}
