{
  description = "habits-phoenix";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    {
      nixosModules.default = let fn = import ./nixos.nix; in fn self;
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_28;
      elixir = beamPackages.elixir_1_19;
    in {
      devShell = pkgs.mkShell {
        buildInputs = [
          elixir
          pkgs.curlie
          beamPackages.expert
          pkgs.inotify-tools
        ];

        shellHook = ''
          mkdir -p .nix-mix .nix-hex
          export MIX_HOME=$PWD/.nix-mix
          export HEX_HOME=$PWD/.nix-mix
          export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
          mix local.hex --force

          export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\"$PWD/.erlang-history\"'"
          export FRONT=http://habits.lcl:3000
        '';
      };

      packages.default = beamPackages.mixRelease {
        src = ./.;
        pname = "habits-phoenix";
        version = "0.1.0";

        FRONT = "https://habits.rusty-cluster.net";
        mixFodDeps = beamPackages.fetchMixDeps {
          pname = "mix-deps-habits-phoenix";
          src = ./.;
          version = "0.1.0";
          hash = "sha256-fCvPNqJLZnwizQIafA3Dt/wKJO/29qBAo+SbBQDR8bc=";
        };

        buildInputs = [elixir];
      };
    });
}
