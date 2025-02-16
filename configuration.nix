{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  # boot
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };
  
  # fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-extra
    fira-code
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
    };
  };
  
  # network
  networking.hostName = "lemon";
  networking.networkmanager.enable = true;
  
  # time and locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  
  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  
  # shell
  users.defaultUserShell = pkgs.fish;

  # programs
  programs.fish.enable = true;
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    neovim
    wget
    rustup
  ];

  # user
  users.users.smit = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # data
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/47792019-1aa0-4de1-943c-3017cf07f8a6"; 
    fsType = "ext4";
    options = [
      "users"
      "nofail"
    ];
  };
  
  # display manager
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # other  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  home-manager.backupFileExtension = "backup";
  system.stateVersion = "24.11";
}
