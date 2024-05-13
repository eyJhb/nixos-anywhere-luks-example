{ lib, ... }:

{
  disko.devices = {
    disk.disk1 = {
      type = "disk";
      device = lib.mkDefault "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        # mode = "mirror";
        rootFsOptions.compression = "zstd";
        # rootFsOptions."com.sun:auto-snapshot" = "false";

        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs snapshot rpool/root@blank";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          "local/stash" = {
            type = "zfs_fs";
            mountpoint = "/state/stash";
            options.mountpoint = "legacy";
          };

          # safe 
          "safe/home" = {
            type = "zfs_fs";
            mountpoint = "/state/home";
            options.mountpoint = "legacy";
          };
          "safe/persistent" = {
            type = "zfs_fs";
            mountpoint = "/state/root";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}

