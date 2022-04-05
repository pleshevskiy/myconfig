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

  programs.git = {
    enable = true;
    userName = secrets.git.name;
    userEmail = secrets.git.email;
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.exa = {
    enable = true;
    # TODO: install zsh and activate aliases
    # enableAliases = true;
  };
}
