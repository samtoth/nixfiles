args@{config, pkgs, ...}:
{

  home.packages = with pkgs; [ 
    ripgrep
    gnumake
    nix-prefetch-git
    tmux
    niv
    cachix
    zoxide
    lorri
    direnv
    appimage-run
    nodePackages.node2nix
    ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      lsl = "ls -l";
      update = "sudo nixos-rebuild switch";
      hms = "home-manager switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
                eval "$(${pkgs.starship}/bin/starship init zsh)"
                eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
                '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };
  };


  # fzf enables fuzzy completion utilities for different shell shortcuts.
  programs.fzf = rec {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --no-ignore --hidden --follow --glob '!.git/*'";
    defaultOptions = [
      "--height=40%"
      "--reverse"
      "--color=fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C"
      "--color=pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B"
    ];
  };

  # Configure starship as the prompt for the shell and enable the basic ZSH
  # integration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
       add_newline = true;
       format = ''
$shlvl$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$haskell$directory$jobs$cmd_duration
$character'';
        shlvl = {
          disabled = false;
          symbol = "ﰬ";
          style = "bright-red bold";
        };
        shell = {
          disabled = false;
          format = "$indicator";
          fish_indicator = "";
          bash_indicator = "[BASH](bright-white) ";
          zsh_indicator = "[ZSH](bright-white) ";
        };
        username = {
          style_user = "bright-white bold";
          style_root = "bright-red bold";
        };
        hostname = {
          style = "bright-green bold";
          ssh_only = true;
        };
        nix_shell = {
          symbol = "";
          format = "[$symbol$name]($style) ";
          style = "bright-purple bold";
        };
        git_branch = {
          only_attached = true;
          format = "[$symbol$branch]($style) ";
          symbol = "שׂ";
          style = "bright-yellow bold";
        };
        git_commit = {
          only_detached = true;
          format = "[ﰖ$hash]($style) ";
          style = "bright-yellow bold";
        };
        git_state = {
          style = "bright-purple bold";
        };
        git_status = {
          style = "bright-green bold";
        };
        directory = {
          read_only = " ";
          truncation_length = 0;
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "bright-blue";
        };
        jobs = {
          style = "bright-green bold";
        };
	haskell = {
	  format = "via [$symbol($version )]($style)";
	};
        character = {
          success_symbol = "[\\$](bright-green bold)";
          error_symbol = "[\\$](bright-red bold)";
        };
    };
  };

  # Lorri, direnv and niv are used to generate, activate and pin development
  # environments.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  
  services.lorri.enable = true;

  programs.git = {
    enable = true;
    userName = "samtoth";
    userEmail = "sam@toth.co.uk";
  };

  programs.alacritty = {
    enable = true;
    settings = import ./allacritty.nix {shell = "zsh";};
  };

  programs.helix = {
    enable = true;
    settings = {
	editor = {
	  line-number  = "relative";

          cursor-shape = {
	    insert = "bar";
            normal = "block";
            select = "underline";
          };

	  # indent-guides.render = true;
	};
    };
  };

  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.vscode = {
    enable = true;
  };

  programs.chromium.enable = true;

  

  services.vscode-server.enable = true;
}
