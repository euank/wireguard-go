{
  description = "wireguard-go";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.treefmt;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            go
            golangci-lint
            gofumpt
            nixfmt-rfc-style
            treefmt
          ];
        };
      }
    );
}
