{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./impermanence/nixos.nix
    ];

  nix.nixPath =
    [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/persist/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # source: https://grahamc.com/blog/erase-your-darlings
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  # source: https://grahamc.com/blog/nixos-on-zfs
  boot.kernelParams = [ "elevator=none" ];

  networking.hostId = "c0ffee42"; # something for zfs
  networking.hostName = "nixos-jason"; # Define your hostname.
  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.dhcpcd.wait = "background";  

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  hardware.opengl.enable = true;

  time.timeZone = "America/Los_Angeles";

  # services.xserver.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # programs.dconf.enable = true;
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs;
    [
      emacs
      zfs
      nano
      git
      firefox
      discord
      pavucontrol
      vlc
      vscodium
      qbittorrent
      python37
      haskell.compiler.ghc902
      cabal-install
      gnome.adwaita-icon-theme
      gnomeExtensions.appindicator

      minicom
      gtkterm
      screen
      kitty

      lutris
      chrome-gnome-shell
      gnome3.adwaita-icon-theme
    ];
  programs.steam.enable=true;
  programs.fish.enable=true;

  #persist
  fileSystems."/persist".neededForBoot = true;
#  environment.etc."NetworkManager/system-connections"= {
#    source = "/persist/etc/NetworkManager/system-connections";
#  };
#  systemd.tmpfiles.rules = [
#    "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
#  ];
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
    ];
  };

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    # TODO: autoReplication
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    hostKeys =
      [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
  };

  services.logind.lidSwitchExternalPower = "ignore"; 
  services.logind.lidSwitch = "suspend-then-hibernate"; 
  # ignore, suspend, suspend-then-hibernate, poweroff, lock

  users = {
    mutableUsers = false;
    users = {
      root = {
        isSystemUser = true;
        passwordFile = "/persist/etc/passwords/root";
      };

      jason = {
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "dialout"];
        group = "users";
        uid = 1000;
        home = "/home/jason";
        shell=pkgs.fish;
	      # useDefaultShell = true;
	      isNormalUser = true;
	      # File contains public keys for allowed SSH clients
        openssh.authorizedKeys.keyFiles = [ /persist/etc/nixos/ssh/authorized_keys ];
        passwordFile = "/persist/etc/passwords/jason";
      };
    };
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
