{
  description = "market-elixir";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_27;
      elixir = beamPackages.elixir_1_17;
    in {
      devShell = pkgs.mkShell {
        buildInputs = [
          elixir
          pkgs.elixir_ls

          pkgs.inotify-tools
        ];

        hooks = ''
          # this allows mix to work on the local directory
          mkdir -p .nix-mix .nix-hex
          export MIX_HOME=$PWD/.nix-mix
          export HEX_HOME=$PWD/.nix-mix
          export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH

          export ERL_AFLAGS="-kernel shell_history enabled"
        '';
      };
    });
}
