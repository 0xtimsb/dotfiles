{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
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
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
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
    sway-contrib.grimshot
    stow
    git
    brightnessctl
    inotifyTools
    vscode
    spotify
    dconf
    xdg-utils
    # for dev
    nodejs_22
    bun
    # for oss
    automake
    ccache
    cmake 
    coreutils 
    gnused # for gnu-sed
    go 
    icu # for icu4c
    libiconv
    libtool
    ninja
    pkg-config
    rustup # for rust
    ruby
    #llvmPackages_16.clangUseLLVM
    #llvmPackages_16.bintools
    #clang_16
    llvmPackages_16.clang-unwrapped
  ];
  system.stateVersion = "24.05"; 
}
