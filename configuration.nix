{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    # ./disk-config.nix
    # ./disk-zfs.nix
    ./disk-luks-zfs.nix
  ];
  networking.hostId = "e1166ac9";
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPuma8g+U8Wh+4mLvZoV9V+ngPqxjuIG4zhsbaTeXq65 eyjhb@chronos"
  ];

  system.stateVersion = "24.05";
}
