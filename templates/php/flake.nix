{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.phpFlake.url = "github:loophp/nix-shell";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, phpFlake, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        NODE_VERSION = "20";
        pkgs = nixpkgs.legacyPackages.${system};
        phpPkgs = phpFlake.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            deno
            phpPkgs.php84

            bashInteractive
          ];
          shellHook = ''
            # Assume installed: fnm
            fnm use ${NODE_VERSION}
          '';
        };
      }
    );
}
