{
  description = "edgepkgs: bleeding edge package set for nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?refs=nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      packages = forAllSystems (system: import ./. { pkgs = import nixpkgs { inherit system; }; });

      overlays.default = import ./overlays;
    };
}
