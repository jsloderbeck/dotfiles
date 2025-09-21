{
  description = "Ramboslod Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
     homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
     };
     homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
     };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask }:
  let
    configuration = { pkgs, config, ... }: {
  	
      nixpkgs.config.allowUnfree = true;

      users.users.jeremysloderbeck= {
	name = "jeremysloderbeck";
	home = "/Users/jeremysloderbeck";
      };

    # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vscode
	  pkgs.mkalias
	  pkgs.bitwarden-desktop
	  pkgs.neovim
	  pkgs.spotify
          pkgs.git
	  pkgs.obsidian
	];

      homebrew = {
	enable = true;
	taps = [
#	 "FelixKratz/formulae" 	
	];
	brews = [
	  "mas"
	];
	casks = [
	  "firefox"
	  "zen"
#	  "sketchybar"
	];
	masApps = {
	  "cliptools" = 1619348240;
	};
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      system.defaults = {
	dock.autohide = true;
	dock.minimize-to-application = true;
	dock.orientation = "left";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."macpro" = nix-darwin.lib.darwinSystem {
      modules = [
	 configuration
	 {
	   system.primaryUser = "jeremysloderbeck";
	 }
	 nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "jeremysloderbeck";

	    autoMigrate = true;

            # Optional: Declarative tap management
             taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
             };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
             mutableTaps = false;
          };
        }
      ];
    };
  };
}
