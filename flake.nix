{ 
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  };

  outputs = inputs@{ nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShell.${system} = import ./shell.nix { inherit pkgs; };
    defaultPackage.${system} = import ./default.nix { inherit pkgs; };
  };
}
