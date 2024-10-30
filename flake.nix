{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        setEnvVars = pkgs.writeShellScriptBin "set-env-vars" (builtins.readFile ./packages/nix/set-env-vars);
        setupPure = pkgs.writeShellScriptBin "setup-pure" (builtins.readFile ./packages/nix/setup-pure);
        getEnvVars = pkgs.writeShellScriptBin "get-env-vars" (builtins.readFile ./packages/nix/get-env-vars);
        getTFVars = pkgs.writeShellScriptBin "get-tf-vars" (builtins.readFile ./packages/nix/get-tf-vars);
        populateCommonVars = pkgs.writeShellScriptBin "populate-vars" (builtins.readFile ./packages/nix/populate-vars);
        getKubeToken = pkgs.writeShellScriptBin "get-kube-token" (builtins.readFile ./packages/nix/get-kube-token);
      in
      {
        devShells.default = pkgs.mkShell {
            name = "dg-shell";
            packages = [
                setupPure
                getEnvVars
                setEnvVars
                getTFVars
                populateCommonVars
                getKubeToken
                pkgs.getopt
#                pkgs.lstat
                pkgs.opentofu
                pkgs.yq
                pkgs.jq
                pkgs.bashInteractive
                pkgs.git
                pkgs.vim
                pkgs.k9s
                pkgs.kubectl
                pkgs.awscli
                pkgs.terraform-docs
                pkgs.terragrunt
                pkgs.sops
            ];
        };
      }
    );
}
