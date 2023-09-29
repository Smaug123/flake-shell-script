{
  description = "Shell-script functions";
  inputs = {};
  outputs = {self}: {
    lib = {
      createShellScript = nixpkgs: name: contents:
        nixpkgs.stdenv.mkDerivation {
          __contentAddressed = true;
          pname = name;
          version = "0.1.0";
          src = contents;

          buildInputs = [
            nixpkgs.shellcheck
          ];

          phases = ["configurePhase" "buildPhase" "installPhase"];

          configurePhase = ''
            ${nixpkgs.shellcheck}/bin/shellcheck "${contents}"
          '';

          buildPhase = ''
            cp "${contents}" run.sh
            patchShebangs run.sh
            sed -i 's_"/bin/sh"_"${nixpkgs.bash}/bin/sh"_' run.sh
            sed -i 's_"/bin/bash"_"${nixpkgs.bash}/bin/bash"_' run.sh
          '';

          installPhase = ''
            mkdir -p $out
            mv run.sh $out/run.sh
          '';
        };
    };
  };
}
