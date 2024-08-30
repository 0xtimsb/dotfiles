{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "oasis";
  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
  ];
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  users.users.tims = {
    isNormalUser = true;
    description = "tims";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };
  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    firefox
    neovim
    sway
    foot
    swayidle
    swaylock
    wl-clipboard
    stow
    git
    brightnessctl
    inotifyTools
    blueman
    vscode
    spotify
    nodejs_22
    bun
  ];
  system.stateVersion = "24.05"; 
}
