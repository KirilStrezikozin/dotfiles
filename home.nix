{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  username = "heiskempler";
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    qtile = {
      subpath = "qtile";
      recursive = true;
    };
    alacritty = {
      subpath = "alacritty";
      recursive = true;
    };
    fastfetch = {
      subpath = "fastfetch";
      recursive = true;
    };
    nvim = {
      subpath = "nvim";
      recursive = false;
    };
  };

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  git-identity = pkgs.writeShellScriptBin "git-identity" (builtins.readFile ./scripts/git-identity);

  languageServersPackages = with pkgs; [
    # Nix
    nil
    nixd
    nixpkgs-fmt

    # Python
    pyright

    typescript-language-server
    lua-language-server

    # Markdown
    marksman
  ];

  toolingPackages = with pkgs; [
    # Python
    uv
    poetry
  ];
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.direnv-instant.homeModules.direnv-instant
  ];

  home.username = username;
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings = {
      user = {
        useConfigOnly = true;

        personal = {
          name = "Kiril Strezikozin";
          email = "kirilstrezikozin@gmail.com";
          signingkey = "D889348893CF6CFE";
          sshkey = "${config.home.homeDirectory}/.ssh/0_ed25519";
        };

        meduzzen = {
          name = "Kiril Strezikozin";
          email = "kiril.strezikozin@meduzzen.com";
          signingkey = "B98D52900CA954AB";
          sshkey = "${config.home.homeDirectory}/.ssh/meduzzen0_ed25519";
        };

        infuse = {
          name = "Kiril Strezikozin";
          email = "k.strezikozin@infusevendors.com";
          signingkey = "2EAA1E19A057B049";
          sshkey = "${config.home.homeDirectory}/.ssh/infuse0_ed25519";
        };
      };
      alias = {
        identity = "! git-identity";
        id = "! git-identity";
      };
      commit.gpgsign = true;
      init.defaultBranch = "main";
    };
    lfs.enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github-personal" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/0_ed25519";
      };
      "github-meduzzen" = {
        hostname = "ssh.github.com";
        port = 443;
        # Or just hostname = "github.com"; without port if outbound ssh works.
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/meduzzen0_ed25519";
      };
      "github-infuse" = {
        hostname = "ssh.github.com";
        port = 443;
        # Or just hostname = "github.com"; without port if outbound ssh works.
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/infuse0_ed25519";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      laz = "lazygit";
      lad = "lazydocker";
    };

    sessionVariables = {
      EDITOR = "nvim";
      _Z_CMD = "in";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "git-auto-fetch"
        "z"
        "poetry"
        "sudo"
        "task"
        "tldr"
      ];
      theme = "jonathan";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
    enableBashIntegration = false;
    nix-direnv.enable = true;

    stdlib = ''
      			#
      			# https://github.com/direnv/direnv/wiki/Customizing-cache-location
      			#
      			: "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      			declare -A direnv_layout_dirs
      			direnv_layout_dir() {
      				local hash path
      				echo "''${direnv_layout_dirs[$PWD]:=$(
      					hash="$(sha1sum - <<< "$PWD" | head -c40)"
      					path="''${PWD//[^a-zA-Z0-9]/-}"
      					echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
      				)}"
      			}
      		  '';
  };

  programs.direnv-instant = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    enableFishIntegration = false;

    settings = {
      mux_delay = 2;
    };
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "a";
    baseIndex = 1;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    mouse = true;
    clock24 = true;
    historyLimit = 50000;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.continuum
    ];

    extraConfig = ''
            # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
            set -g default-terminal "xterm-256color"
            set -ga terminal-overrides ",*256col*:Tc"
            set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
            set-environment -g COLORTERM "truecolor"

            # easy-to-remember split pane commands
            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            bind c new-window -c "#{pane_current_path}"

      	  set-option -g @continuum-restore 'on'
    '';
  };

  programs.keepassxc = {
    enable = true;
    settings = {
      GUI.ApplicationTheme = "dark";
      Browser.Enabled = true;
      FdoSecrets.Enabled = true;
      SSHAgent.Enabled = true;
    };
  };

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.awscli = {
    enable = true;
    settings = {
      "sso-session infuse" = {
        sso_start_url = "https://infusemedia.awsapps.com/start/";
        sso_region = "us-east-1";
        sso_registration_scopes = "sso:account:access";
      };

      "profile VoiceAgentEKSDashboardAccess-058264301975" = {
        sso_session = "infuse";
        sso_account_id = "058264301975";
        sso_role_name = "VoiceAgentEKSDashboardAccess";
        region = "us-east-1";
        output = "yaml";
      };
    };
  };

  xdg.configFile = lib.mkMerge [
    (builtins.mapAttrs (name: config: {
      source = create_symlink "${dotfiles}/${config.subpath}";
      recursive = config.recursive;
    }) configs)
    {
      "BraveSoftware/Brave-Browser/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".text =
        builtins.toJSON
          {
            name = "org.keepassxc.keepassxc_browser";
            description = "KeePassXC integration with native messaging support";
            path = "${pkgs.keepassxc}/bin/keepassxc-proxy";
            type = "stdio";
            allowed_origins = [ "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/" ];
          };
    }
  ];

  home.packages =
    with pkgs;
    [
      # Support
      git-identity
      ripgrep
      fzf
      tldr # Commands cheatsheet better than man pages
      lazygit
      lazydocker
      brightnessctl
      pavucontrol
      fastfetch
      btop
      maim # Screenshot
      imv # Viewer
      feh
      zip
      unzip
      ffmpeg
      glow
      gh

      # Essential
      neovim
      alacritty
      tree-sitter
      nodejs
      xclip
      gcc

      brave
      vesktop # Discord
      moonlight-qt
      zathura
      openvpn
      telegram-desktop
      parsec-bin
      obsidian
      bun

      xhost
    ]
    ++ languageServersPackages
    ++ toolingPackages;
}
