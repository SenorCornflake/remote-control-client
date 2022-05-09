{ pkgs, ... }:

pkgs.python3Packages.buildPythonPackage rec {
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
}
