# Derived from nixpkgs: Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors
# See COPYING-NIXPKGS for license details.
# Original: https://github.com/NixOS/nixpkgs/blob/4d256032cc83a2eccc3d366f596a7bf69c87f62d/pkgs/by-name/cl/claude-code/package.nix

{
  lib,
  buildNpmPackage,
  fetchzip,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
buildNpmPackage (finalAttrs: {
  pname = "claude-code";
  version = "2.1.16";

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${finalAttrs.version}.tgz";
    hash = "sha256-UntOj79uzi7W9uELYTrJJD59fm1JxS8d4NF/3DkMxWU=";
  };

  npmDepsHash = "sha256-xB6QPMhhz6pOoC9Qie1WXyAFGTnXxvyaf3P+gHvpo+c=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  env.AUTHORIZED = "1";

  # `claude-code` tries to auto-update by default, this disables that functionality.
  # https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#environment-variables
  # The DEV=true env var causes claude to crash with `TypeError: window.WebSocket is not a constructor`
  postInstall = ''
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --unset DEV
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      natsukium
    ];
    mainProgram = "claude";
  };
})
