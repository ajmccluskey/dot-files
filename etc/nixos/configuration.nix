# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./machine-specific.nix
    ];

  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://nixcache.reflex-frp.org"
    "http://hydra.qfpl.io"
  ];

  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  sound.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.bluetooth.enable = true;
  # hardware.pulseaudio = {
  #   enable = true;
  #   # Get a lightweight package by default. Need full to support BT audio.
  #   package = pkgs.pulseaudioFull;
  # };


  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # SEE .nixpkgs/config.nix for installed packages
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = (with pkgs; [
    exfat
    exfat-utils
    fuse_exfat
  ]);

  programs.fish.enable = true;
  programs.bash.enableCompletion = true;

  # Enable virtualisation - otherwise get missing vboxdrv error
  virtualisation.virtualbox.host.enable = true;
  # virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable yubikey
  services.pcscd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Handle lid close
  # THESE ARE APPARENTLY THE DEFAULTS
  # services.logind.extraConfig = ''
  #   HandleLidSwitch=suspend
  #   HandlePowerKey=hibernate
  #   HandleLidSwitchDocked=ignore
  # '';

  # Enable upower service - used by taffybar's battery widget
  services.upower.enable = true;
  powerManagement.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    displayManager.slim.defaultUser = "andrew";
    # Try SLiM as the display manager
    # displayManager.lightdm.enable = true;
    xkbOptions = "ctrl:nocaps";

    windowManager.default = "xmonad";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages : [haskellPackages.taffybar];
    };

    # synaptics = {
    #   enable = true;
    #   twoFingerScroll = true;
    #   horizontalScroll = true;
    #   tapButtons = true;
    #   palmDetect = true;
    #   additionalOptions = ''
    #   Option            "VertScrollDelta"  "-111"
    #   Option            "HorizScrollDelta" "-111"
    #   '';
    # };

    libinput = {
      enable = true;
      naturalScrolling = true;
    };
  };

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.andrew = {
    createHome = true;
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager" "docker" "vboxusers"];
    group = "users";
    home = "/home/andrew";
    isNormalUser = true;
    shell = pkgs.fish;
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
