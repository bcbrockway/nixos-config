# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, outputs, lib, config, pkgs, hostname, specialArgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/${hostname}.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "uk";
    useXkbConfig = true; # use xkb.options in tty.
  };
  services.xserver.xkb.layout = "gb";

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = ["UbuntuMono Nerd Font"];
        sansSerif = ["UbuntuSans Nerd Font"];
        serif = ["Ubuntu Nerd Font"];
      };
    };
    packages = with pkgs; [
      nerdfonts
    ];
  };

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable =  true;
  users = {
    defaultUserShell = pkgs.zsh;
    users.bbrockway = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        tree
      ];
    };
  };

  # programs.firefox.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    firefox
    font-manager
    git
    google-chrome
    greetd.tuigreet  # Greeter for launching window managers / desktop environments
    nautilus
    networkmanagerapplet
    pipewire  # Replacement for PulseAudio, ALSA and JACK. Also helps us to screen-share in Wayland.
    pwvucontrol # pavucontrol replacement for Pipewire
    seahorse  # For managing keys and passwords in the gnome-keyring
    vim
    wget
  ];
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
    extraOptions = ["--unsupported-gpu"];
    extraPackages = with pkgs; [
      brightnessctl
      clipman
      flameshot
      foot
      kanshi  # autorandr replacement
      swayidle
      swaylock
      wmenu
      wdisplays
    ];
    extraSessionCommands = ''
      # vscode needs this to properly set gnome-keyring as its password store
      # https://code.visualstudio.com/docs/configure/settings-sync#_linux
      export DESKTOP_SESSION=gnome
    '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.flatpak.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;  
      wlr.enable = true;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
