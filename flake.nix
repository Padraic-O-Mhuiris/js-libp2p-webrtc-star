{
  description = "js-libp2p-webrtc-star";

  inputs = {
    nixpkgs.url = "github:Padraic-O-Mhuiris/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";

  };
  outputs = inputs@{ self, nixpkgs, flake-utils, nix-filter, ... }:
    let
      inherit (nixpkgs.lib) recursiveUpdate;
      inherit (flake-utils.lib) eachDefaultSystem defaultSystems;
    in eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) mkShell buildNpmPackage;
      in {
        packages.default = buildNpmPackage {
          name = "libp2p-webrtc-star";
          src = nix-filter.lib {
            root = ./.;
            exclude = [ (nix-filter.lib.matchExt "nix") "flake.lock" ];
          };
          npmDepsHash = "sha256-M/C3C2tfavTcbr8YvBnqpaHd14fnKFMf2McJ1cVxIYI=";
          makeCacheWritable = true;
          npmFlags = [ "--verbose" ];
        };
        devShell =
          mkShell { buildInputs = with pkgs; [ nodejs prefetch-npm-deps ]; };
      });
}
