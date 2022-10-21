#!/usr/bin/env sh

set -x

fhsShellName="rescript-vscode-install-compile"
fhsShellDotNix="{pkgs ? import <nixpkgs> {} }: (pkgs.buildFHSUserEnv { name = \"${fhsShellName}\"; targetPkgs = pkgs: [pkgs.nodejs]; runScript = \"npm install\"; }).env"
nix-shell - <<<"$fhsShellDotNix"

theLd=$(patchelf --print-interpreter $(which mkdir))
patchelf --set-interpreter $theLd ./node_modules/rescript/linux/*.exe
# patchelf --set-interpreter $theLd ./node_modules/bisect_ppx/bisect-ppx-report
theSo=$(find /nix/store/*$fhsShellName*/lib64 -name libstdc++.so.6 | head -n 1)
patchelf --replace-needed libstdc++.so.6 $theSo ./node_modules/rescript/linux/ninja.exe
