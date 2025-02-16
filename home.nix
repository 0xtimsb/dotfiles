{ config, pkgs, ... }:

{
  home = {
    username = "smit";
    homeDirectory = "/home/smit";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      spotify
      zoxide
      ffmpeg
      slack
      zed-editor
      ghostty
    ];
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "smit";
    userEmail = "0xtimsb@gmail.com";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      gs = "git status";
      gc = "git commit";
      gd = "git diff";
      gl = "git log";
      gp = "git pull";
    };
    shellInit = ''
      set -g fish_greeting ""
      zoxide init fish | source
    '';
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
	set mouse=a
	set clipboard=unnamedplus
	set fileencoding=utf-8
	set nobackup
	set nowritebackup
	set noswapfile
	set ignorecase
	set smartindent
	set autoindent
	set termguicolors
	set undofile
	set belloff=all

	set number
	set relativenumber
	set nowrap

	set tabstop=2
	set softtabstop=2
	set shiftwidth=2
	set expandtab
    '';
  };

  home.stateVersion = "24.11";
}
