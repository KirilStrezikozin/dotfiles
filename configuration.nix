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
      layout = "us,ua";
      variant = "";
      options = "grp:alt_space_toggle";
    };
  };

  services.displayManager.ly.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
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

  programs.nix-ld.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.heiskempler = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
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

  services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  system.stateVersion = "26.05";
}
