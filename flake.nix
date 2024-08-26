{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          pythonPackages = pkgs.python312Packages;
          pygbag =
            let
              pname = "pygbag";
              version = "0.9.2";
            in
              pythonPackages.buildPythonPackage rec {
                inherit pname version;
                pyproject = true;
                src = pkgs.fetchPypi {
                  inherit pname version;
                  sha256 = "sha256-DjGGB0KoupxScTXLttZPbX2NeyO3Huh6FfHelHRpDCU=";
                };
                build-system = [
                  pythonPackages.setuptools
                ];
              };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs = [
              python3
              pythonPackages.pygame
              pythonPackages.black
              pygbag
              ffmpeg
            ];
          };
        }
      );
}
