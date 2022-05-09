{ pkgs, ... }:

let
  python3 = (pkgs.python3.withPackages (p: with p; [
    requests
    typer
  ]));
in
pkgs.mkShell {
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
}
