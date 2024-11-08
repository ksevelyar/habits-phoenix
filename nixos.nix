self: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.habits-phoenix;
in {
  options.services.habits-phoenix = {
    enable = mkEnableOption "enable the habits-phoenix service";
  };

  config = mkIf cfg.enable {
    systemd.services.habits-phoenix = {
      description = "habits-phoenix";
      wantedBy = ["multi-user.target"];
      after = ["postgresql.service"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${self.packages.${pkgs.system}.default}/bin/habits start";
        Restart = "on-failure";
        ProtectHome = "read-only";
      };
    };
  };
}
