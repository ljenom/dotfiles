{ pkgs, lib, ... }:
{
  home.username = "leonq";
  home.homeDirectory = "/Users/leonq";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    ripgrep fd fzf bat eza zoxide jq yq htop tldr
    gh httpie
    nodePackages.pnpm nodePackages.yarn
    jenv
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [ "git" "docker" "macos" "z" "fzf" ];
    };
    shellAliases = {
      ll   = "eza -la --icons";
      ls   = "eza --icons";
      cat  = "bat";
      cd   = "z";
      gs   = "git status";
      gp   = "git push";
      gl   = "git pull";
      gco  = "git checkout";
      gcb  = "git checkout -b";
      nrs  = "darwin-rebuild switch --flake ~/.dotfiles";
      brewski = "brew update && brew upgrade && brew cleanup";
    };
    sessionVariables = {
      EDITOR = "code --wait";
      LANG   = "en_US.UTF-8";
    };
    initExtra = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

      export PATH="$HOME/.jenv/bin:$PATH"
      eval "$(jenv init -)"

      eval "$(zoxide init zsh)"

      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
      git_branch.symbol = " ";
      nodejs.symbol     = " ";
      java.symbol       = " ";
      package.disabled  = true;
    };
  };

  programs.git = {
    enable = true;
    userName  = "Leon Quattlebaum";
    userEmail = "leonquattlebaum@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "code --wait";
      diff.colorMoved = "default";
      credential.helper = "osxkeychain";
    };
    aliases = {
      lg = "log --oneline --graph --decorate --all";
      st = "status -sb";
      co = "checkout";
    };
    ignores = [
      ".DS_Store" "*.orig" ".env.local" ".idea/" ".vscode/" "node_modules/"
    ];
  };

  home.file.".ssh/config".text = ''
    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
  '';

  # Karabiner — uncomment after placing karabiner.json in home/
  # home.file.".config/karabiner/karabiner.json" = {
  #   source = ./karabiner.json;
  #   force  = true;
  # };

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
