# edgepkgs: bleeding edge package set for nix

A Nix package set for bleeding edge software. This repository contains packages that receive frequent updates or track unreleased Git HEAD versions.

## Available Packages

- claude-code [./pkgs/claude-code/default.nix](./pkgs/claude-code/default.nix)
- claude-code-bin [./pkgs/claude-code-bin/default.nix](./pkgs/claude-code-bin/default.nix)

## Usage

### Using Overlays

Add the overlay to your nixpkgs configuration:

```nix
nixpkgs.overlays = [ inputs.edgepkgs.overlays.default ];
```

This makes all packages from edgepkgs available in your system with the `edge` prefix.

Example:

```nix
environment.systemPackages = [ pkgs.edge.claude-code ];
```

### Direct Package Reference

You can also reference packages directly from the flake:

```nix
environment.systemPackages = [
  inputs.edgepkgs.packages.${system}.claude-code
];
```

## Important Notice

This package set is automatically updated without manual review. Use at your own risk.

## Contributing

Contributions are welcome in the following areas:

### Adding Packages

You may add new packages freely, but please prioritize packages with high update frequency (daily updates or more). For packages with slower release cycles, consider contributing to [nixpkgs](https://github.com/NixOS/nixpkgs) instead.

### Updating Packages

Package updates are welcome. To improve automation, consider adding an update script for your package.

### Fixing Packages

Automated updates may cause build failures due to definition mismatches. If you find broken packages, please fix the definitions accordingly.

### Attribution

When adapting packages from nixpkgs, please remove the original maintainer list and add yourself as the maintainer. The original maintainers are responsible for nixpkgs, not this derivative project. Do not contact them regarding issues in this project.

## License

MIT License

This project includes packages derived from [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs). See [COPYING-NIXPKGS](./COPYING-NIXPKGS) for the nixpkgs license.
