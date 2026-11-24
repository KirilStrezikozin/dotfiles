{ config
, pkgs
, ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "heiskempler";

  networking.extraHosts = ''
    127.0.0.1 marketing-agent.localhost
    ::1       marketing-agent.localhost
  '';

  networking.networkmanager.enable = true;

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

  time.timeZone = "Europe/Amsterdam";

  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      extraPackages =
        python3Packages: with python3Packages; [
          qtile-extras
        ];
    };
    xkb = {
      layout = "us,ua,ru";
      variant = "";
      options = "grp:alt_space_toggle";
    };
	videoDrivers = [ "displaylink" "modesetting" ];
  };

  services.displayManager.ly.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.uinput.enable = true;

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
	extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	config.commong.default = "*";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };

    extraConfig = ''
      [server]
      use-ipv4=yes
      use-ipv6=yes
      deny-interfaces=docker0,veth*,br-*
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.tailscale.enable = true;

  services.udev.packages = with pkgs; [
    platformio-core.udev
  ];

  programs.nix-ld.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.heiskempler = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "input" "uinput" "dialout" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git

	displaylink
  ];

  environment.variables.EDITOR = "vim";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback evdi ];
  boot.kernelModules = [ "v4l2loopback" "uinput" "evdi" ];

  system.stateVersion = "26.05";
}
