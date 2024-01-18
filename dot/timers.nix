{pkgs, ...} : {

  systemd.user.timers."rclone_backup" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "100m";
        OnUnitActiveSec = "100m";
        Unit = "rclone_backup.service";
      };
  };

  systemd.user.services."rclone_backup" = {
    path = [
      pkgs.rclone
    ];
    script = ''
      rclone sync gdrive:/ ~/sync
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

}
