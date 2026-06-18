{ pkgs, lib, ... }:
{
  home.username = "leonq";
  home.homeDirectory = lib.mkForce "/Users/leonq";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    # CLI essentials
    ripgrep fd fzf bat eza zoxide jq yq htop tldr
    # Dev tools
    gh httpie neovim go
    # Node package managers
    nodePackages.pnpm nodePackages.yarn
    # Java version management
    jenv
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "docker" "macos" "z" "fzf" ];
    };
    shellAliases = {
      # File listing
      l          = "eza -laF";
      "ö"        = "eza -laF";
      ll         = "eza -la --icons";
      ls         = "eza --icons";
      cat        = "bat";
      # Navigation
      cd         = "z";
      # Git
      gs         = "git status";
      gp         = "git push";
      gl         = "git pull";
      gco        = "git checkout";
      # Gradle
      gcb        = "./gradlew clean build";
      gb         = "./gradlew build";
      # Docker Compose
      dc         = "docker-compose";
      dcupd      = "docker-compose up -d";
      dcupdf     = "docker-compose up -d --build --force-recreate";
      dcdn       = "docker-compose down";
      # Node cleanup
      clear-node = "find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +";
      # Local LLM
      llama      = "llama-server -hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q6_K_XL --port 51000 -c 32768 --n-gpu-layers 999";
      # Work logins
      ds-login   = "aws sso login && aws codeartifact login --tool npm --domain dst-package-registry --repo npm --namespace @derstandard";
      do-login   = "npx google-artifactregistry-auth ~/.npmrc";
      # Nix
      nrs        = "darwin-rebuild switch --flake ~/.dotfiles";
      brewski    = "brew update && brew upgrade && brew cleanup";
    };
    sessionVariables = {
      EDITOR = "code --wait";
      LANG   = "en_US.UTF-8";
    };
    initExtra = ''
      # PATH additions
      export PATH="$HOME/.jenv/bin:$PATH"
      export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
      export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
      export GOPATH="$HOME/go"
      export PATH="$GOPATH/bin:$PATH"

      # NVM (managed via Homebrew)
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

      # jenv
      eval "$(jenv init -)"
      jenv enable-plugin export

      # zoxide
      eval "$(zoxide init zsh)"

      # fzf
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

      # Angular CLI autocompletion
      command -v ng &>/dev/null && source <(ng completion script)

      # opencode-memory wrapper
      opencode() {
        command opencode-memory "$@"
      }

      # Jump to direnv project root
      root() {
        if [[ -n "''${PROJECT_ROOT:-}" ]]; then
          cd "$PROJECT_ROOT"
        else
          print -u2 "root: PROJECT_ROOT is not set (enter a direnv-enabled project directory first)"
          return 1
        fi
      }
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
      core = {
        editor = "code --wait";
        autocrlf = "input";
      };
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
    # OrbStack SSH (must remain first)
    Include ~/.orbstack/ssh/config

    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
  '';

  home.file.".config/karabiner/karabiner.json" = {
    source = ./karabiner.json;
    force  = true;
  };

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
