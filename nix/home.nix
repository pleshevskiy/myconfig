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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";

    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName = secrets.git.name;
    userEmail = secrets.git.email;
    extraConfig = {
      core.editor = "nvim";
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

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  xdg.configFile = {
    "alacritty/alacritty.yml".source = ../programs/alacritty/alacritty.yml;
  };
}
