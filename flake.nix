{ 
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  };

  outputs = inputs@{ nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    python3 = (pkgs.python3.withPackages (p: with p; [
      requests
      typer
    ]));
  in
  {
    devShell.${system} = pkgs.mkShell {
      buildInputs = [
        python3
      ];
      shellHook = ''
        PYTHONPATH=${python3}/${python3.sitePackages}
        # maybe set more env-vars
        any-nix-shell zsh --info-right | source /dev/stdin

        # Overwrite the nix-shell command
        function nix-shell () {
            /nix/store/l41p2v55xrxc5jz7yd3iasy3xkl5f1j5-any-nix-shell-1.2.1/bin/.any-nix-shell-wrapper zsh "$@"
        }

        # Overwrite the nix command
        function nix () {
            if [[ $1 == shell ]]; then
                shift
                /nix/store/l41p2v55xrxc5jz7yd3iasy3xkl5f1j5-any-nix-shell-1.2.1/bin/.any-nix-wrapper zsh "$@"
            else
                command nix "$@"
            fi
        }
      '';
    };

    defaultPackage.${system} = pkgs.python3Packages.buildPythonPackage rec {
      pname = "remote-control-client";
      version = "1.0.0";
      src = ./.;

      propagatedBuildInputs = with pkgs; [
        python3Packages.typer
        python3Packages.requests
        python3Packages.setuptools
      ];

      postInstall = ''
        mv -v $out/bin/main.py $out/bin/remote-control-client
      '';
    };
  };
}
