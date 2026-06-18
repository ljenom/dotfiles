{ pkgs, ... }:
{
  networking.hostName = "Leons-MacBook-Pro-2";

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "root" "leonq" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      minimize-to-application = true;
      show-recents = false;
      tilesize = 48;
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
    taps = [ "homebrew/cask-fonts" ];
    brews = [ "mas" ];
    casks = [
      "warp"
      "visual-studio-code"
      "tableplus"
      "raycast"
      "bettertouchtool"
      "karabiner-elements"
      "jordanbaird-ice"
      "arc"
      "firefox"
      "slack"
      "zoom"
      "font-jetbrains-mono-nerd-font"
      "temurin@21"
      "temurin@17"
    ];
    masApps = {};
  };

  environment.systemPackages = with pkgs; [ git curl wget ];
  programs.zsh.enable = true;
  system.stateVersion = 5;
}
