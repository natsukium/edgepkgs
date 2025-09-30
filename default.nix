{
  pkgs ? import <nixpkgs> { },
}:
{
  claude-code = pkgs.callPackage ./pkgs/claude-code { };
}
