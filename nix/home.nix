{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in
{
  nixpkgs.overlays = [
    (self: super: {
      haskellPackages = super.haskellPackages.override {
        overrides = hself: hsuper: {
          xmonad = hsuper.xmonad_0_17_0;
          xmonad-contrib = hsuper.xmonad-contrib_0_17_0;
          xmonad-extras = hsuper.xmonad-extras_0_17_0;
        };
      };
    })
  ];

  targets.genericLinux.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = secrets.home.name;
  home.homeDirectory = secrets.home.dir;

  home.keyboard = {
    model = "pc105";
    layout = "us,ru";
    variant = "dvorak,";
    options = ["grp:win_space_toggle"];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    # system ui
    dmenu           # menu for x window system
    flameshot       # powerful yet simple to use screenshot software

    # tools
    xh              # friendly and fast tool for sending HTTP requests
    fd              # a simple, fast and user-friendly alternative to find
    bat             # a cat clone with syntax highlighting and git integration

    # haskell
    stylish-haskell # formatter

    # database
    postgresql_12   # 🤷 I need only psql

    # browser
    librewolf       # a fork of firefox, focused on privacy, security and freedom
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xsession = {
    enable = true;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  services.trayer = {
    enable = true;
    settings = {
      SetDockType = true;
      SetPartialStrut = true;
      expand = true;
      transparent = true;
      alpha = 0;
      edge = "top";
      align = "right";
      width = 4;
      height = 20;
      tint = "0xff222222";
    };
  };

  services.screen-locker = {
    enable = true;

    lockCmd = "/bin/bash ~/scripts/lock.sh";

    inactiveInterval = 5;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # enable z shell
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
      ignorePatterns = [
        "rm *"
        "kill *"
      ];
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };

    initExtraFirst = ''
      # nix
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
        source $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi

      source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}

      # ghcup
      if [ -f "$HOME/.ghcup/env" ]; then
        source "$HOME/.ghcup/env"
      fi
    '';
  };

  # enable git VCS
  programs.git = {
    enable = true;
    userName = secrets.git.name;
    userEmail = secrets.git.email;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
    aliases = {
      co = "checkout";
      st = "status -sb";
      d = "diff";
      dc = "diff --cached";
      aa = "add .";
      ai = "add -i";
      c = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      cam = "commit --amend -m";
      can = "commit --amend --no-edit";
      p = "push";
      pf = "push --force-with-lease";
      rb = "rebase";
      rbi = "rebase -i";
    };
  };

  # replacement for 'ls' written in rust
  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  # a fast cd command that learns your habbits
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file = {
    "scripts" = {
      source = ../scripts;
      recursive = true;
    };

    "pictures/wallpapers" = {
      source = ../wallpapers;
      recursive = true;
    };
  };

  xdg = {
    enable = true;
    configFile = {
      # add config for alacritty terminal
      "alacritty/alacritty.yml".source = ../programs/alacritty/alacritty.yml;

      # add config for xmonad window manager
      # "xmonad/xmonad.hs".source = ../programs/xmonad/xmonad.hs;
      # "xmobar/xmobar.hs".source = ../programs/xmonad/xmobar.hs;

      "stylish-haskell/config.yaml".source = ../programs/stylish-haskell/config.yml;
    };
  };
}
