{
  home = {
    username = "bbrockway";
    homeDirectory = "/home/bbrockway";
    keyboard.layout = "uk";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.padding.x = 7;
      window.padding.y = 7;
      font.size = 10;
      selection.save_to_clipboard = true;
      mouse.bindings = [{mouse = "Right"; action = "PasteSelection";}];
      keyboard.bindings = [
        {key = "Up"; mods = "Shift"; action = "ScrollLineUp";}
        {key = "Down"; mods = "Shift"; action = "ScrollLineDown";}
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Bobby Brockway";
    userEmail = "bobby.brockway@gmail.com";
  };

  programs.vscode = {
    enable = true;
  };
 
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
    };
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "kubectl"];
      theme = "robbyrussell";
    };
  };

  xdg.configFile."sway/config".source = ./dotfiles/sway/config;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
