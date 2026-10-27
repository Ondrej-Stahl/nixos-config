# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.timeout = 0;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [ "interface-name:wg0" ];
  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "cs_CZ.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Enable i3 as an alternative window manager (selectable at login)
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      i3status
      i3lock
    ];
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cz";
    variant = "winkeys";
  };

  # Configure console keymap
  console.keyMap = "cz-lat2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  systemd.services.disable-hda-automute = {
    description = "Disable HDA Auto-Mute Mode";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" ];
    serviceConfig.Type = "oneshot";
    script = "${pkgs.alsa-utils}/bin/amixer -c1 sset 'Auto-Mute Mode' Disabled || true";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ondy" = {
    isNormalUser = true;
    description = "ondy";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "rns" "lxmf" "nomadnet" ];



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    pkgs.xfce4-pulseaudio-plugin
    fastfetch
    git
    btop
    htop
    kdePackages.falkon
    pkgs.vim
    pkgs.cmatrix
    pkgs.tty-clock
    pkgs.qutebrowser
    pkgs.dysk
    pkgs.vscodium
    pkgs.vlc
    pkgs.pipes
    pkgs.alsa-utils
    pkgs.mapscii
    pkgs.figlet
    pkgs.evtest
    pkgs.gparted
    wineWow64Packages.stable
    winetricks
    pkgs.tmux
    pkgs.emacs
    pkgs.chirp
    pkgs.firefox
    autorandr
    pkgs.feh
    pkgs.brightnessctl
    pkgs.xev
    pkgs.xdotool
    alacritty
    (st.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        (fetchpatch {
          url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.9.2.diff";
          sha256 = "sha256-ZypvRONAHS//wnZjivmqpWIqZlKTqAQ0Q8DhQpZVaqU=";
        })
      ];
    }))
    rxvt-unicode
    pkgs.luakit
    cbonsai
    xclock
    pkgs.freecad
    pkgs.libreoffice
    rns
    python3Packages.nomadnet
    pkgs.wireguard-tools
    pkgs.nmap
  ];

  services.tailscale.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };


  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
  };

  services.udev.packages = [ pkgs.brightnessctl ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  swapDevices = [
      { device = "/var/swapfile"; size = 8192; }
  ];
networking.wireguard.interfaces.wg0 = {
  ips = [ "10.X.X.2/24" ];
  privateKeyFile = "/home/ondy/wg-laptop.key";
  peers = [{
    publicKey = "F0sXI172WQwnWQCMx1WivTwNnYQGLF8++eBx5/W3Tlw=";
    allowedIPs = [ "10.X.X.0/24" ];
    endpoint = "X.X.X.X:51820";
    persistentKeepalive = 25;
  }];
};
}
