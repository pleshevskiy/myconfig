{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = secrets.home.name;
  home.homeDirectory = secrets.home.dir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.packages = [
    pkgs.xh             # friendly and fast tool for sending HTTP requests
    pkgs.fd             # a simple, fast and user-friendly alternative to find
    pkgs.bat            # a cat clone with syntax highlighting and git integration

    pkgs.postgresql_12  # 🤷 I need only psql
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
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
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
        source $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi

      source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}
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
      ci = "commit";
      cia = "commit --amend";
      cian = "commit --amend --no-edit";
      st = "status -sb";
      fpush = "push --force-with-lease";
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

  xdg.configFile = {
    "alacritty/alacritty.yml".source = ../programs/alacritty/alacritty.yml;
  };
}
