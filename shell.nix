{ pkgs ? import <nixpkgs> {} } :

pkgs.mkShell {
  buildInputs = [
    pkgs.bash
    pkgs.which
    pkgs.curl
    pkgs.git
    pkgs.temurin-bin-17
  ];

  shellHook = ''
    echo NIX SHELL ACTIVATED
  '';

  MY_ENVIRONMENT_VARIABLE = "world";


}

