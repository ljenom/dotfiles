{ pkgs, user, host, ... }:
{
  system.primaryUser = user;
  networking.hostName = host;

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "root" user ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      minimize-to-application = true;
      show-recents = false;
      tilesize = 40;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    screencapture = {
      location = "~/Desktop/Screenshots";
      type = "png";
      disable-shadow = true;
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = [];
    brews = [
      "mas"
      "nvm"
      "azure-cli"
      "cocoapods"
      "maven"
      "k6"
    ];
    casks = [
      # Terminal & editors
      "warp"
      "visual-studio-code"
      # Dev tools
      "orbstack"
      "tableplus"
      "ngrok"
      "dotnet-sdk"
      "claude-code"
      # Productivity
      "raycast"
      "bettertouchtool"
      "karabiner-elements"
      "jordanbaird-ice"
      # Browsers
      "arc"
      "firefox"
      # Communication
      "slack"
      "zoom"
      # Fonts
      "font-jetbrains-mono-nerd-font"
      # JDKs
      "temurin@21"
      "temurin@17"
    ];
    masApps = {};
  };

  environment.systemPackages = with pkgs; [ git curl wget ];
  programs.zsh.enable = true;
  system.stateVersion = 5;
}
