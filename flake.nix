{
  description = "Bash breaking changes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        bash31 = pkgs.stdenv.mkDerivation rec {
          pname = "bash";
          version = "3.1";
          src = pkgs.fetchurl {
            url = "mirror://gnu/bash/bash-${version}.tar.gz";
            sha256 = "sha256-1pUrLDj5v0F1Wd07Bxhg4Qmd37ihLAIo8ir69H9507k=";
          };
          buildInputs = [ pkgs.ncurses ];
          nativeBuildInputs = [ pkgs.gcc ];
          
          env.NIX_CFLAGS_COMPILE = "-std=gnu89 -Wno-implicit-function-declaration -Wno-format -Wno-deprecated-non-prototype -Wno-return-mismatch -Wno-incompatible-pointer-types";
          
          configureFlags = [ 
            "--without-bash-malloc" 
            "--disable-nls"
          ];
        };

        # Use modern bash from nixpkgs
        bashModern = pkgs.bash;

        # Helper function to create test script runner
        makeTestRunner = bashPkg: pkgs.writeShellScriptBin "test-runner" ''
          export PATH=${pkgs.coreutils}/bin:$PATH
          ${bashPkg}/bin/bash ./test.sh 2>/dev/null
        '';
      in
      {
        packages = {
          bash31 = bash31;
          bashModern = bashModern;
          default = bash31;
        };

        apps = {
          testbash3-1 = {
            type = "app";
            program = "${makeTestRunner bash31}/bin/test-runner";
          };
          testbash-modern = {
            type = "app";  
            program = "${makeTestRunner bashModern}/bin/test-runner";
          };
        };
      }
    );
}
