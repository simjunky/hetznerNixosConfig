{
	modulesPath,
	lib,
	pkgs,
	...
} @ args:
{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
		(modulesPath + "/profiles/qemu-guest.nix")
		./disk-config.nix
		./hardware-configuration.nix
	];

	boot.loader.grub = {
		# no need to set devices, disko will add all devices that have a EF02 partition to the list already
		# devices = [ ];
		efiSupport = true;
		efiInstallAsRemovable = true;
	};

	# Automatic Cleanup of old versions
	nix.gc.automatic = true;
	nix.gc.dates = "monthly";
	nix.gc.options = "--delete-older-than 14d";
	nix.settings.auto-optimise-store = true;

	# Enable Nix Flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	networking.hostName = "hetznerwpvps"; # Define your hostname.

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		settings = {
			PermitRootLogin = "no"; # No login as root
			PasswordAuthentication = false; # No login via password, only via ssh keypairs. See user.
			KbdInteractiveAuthentication = false; # Also no other method of Authentication (PW Auth is only one way to do it)
		};
	};

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.patrick = {
		isNormalUser = true;
		initialPassword = "initpw"; # Change this at first login!
		description = "patrick";
		extraGroups = [ "networkmanager" "wheel" "backup" ];
		# Preset public keys for login via ssh
		openssh.authorizedKeys.keys = [
			# filepaths also allowed, e.g. /etc/nixos/ssh/authorized_keys
			"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC82+6h01ZotRKNfEtBPSs6r+8BgGBe7vdwfCignSS1OYcqRZDKODjFgnSbDzl444froWjrp4znKkEKrzHyTGhQizKYcSPHhbMZV15ntggUsy7xkmoxOoc2NfP5F7blSedzO36IK7bnGijnkiUrVWqL5aXVkQSvlFCVZ4adVw8JWGdmYOwkf0TuQi7BWpPG6w64ulcHkprKp3yz416dwwIt+OVsuVFtd29z1ggGDJIXBF1y5ypwEdoQP18f7E2chwGmq3EFxKmN3MaZPM9PCJwj2h9K2xg3Ekj2t8GnGSIpQkRGIjboXTvQMMkCxfYwEC8jVxmEj4upxhc8ZmQZgI29YtkacVStQWlXIEeKWigi4yVlM2szFM8AgosvqBriPbYYZ0xrazxkB8DWUt4HCkzBLg61EFTsk33L4XgzLaj9wU23PIXPjHvWuQA+nhEVYfa0UO79y1nJe3XtbmoBHZAhOB6khDNaXvx4ObeYXbEzAL5o770aoV/97rWBDk9wCv0= patrick"
		];
	};
	# better keep the pw usage for wheel on this system (default)
	security.sudo.wheelNeedsPassword = false; # since no root user pw has ever been set.

	environment.systemPackages = [
		# the nano texteditor is installed by default
		pkgs.bat # cat clone with syntax highlighting.
		pkgs.fastfetch # Quick OS and hardware info at a glance.
		pkgs.fd # better find tool for CLI.
		pkgs.fzf # Fuzzy Find Command Line Tool.
		pkgs.htop # Process and CPU/MEM usage overview panel.
		pkgs.lf # File manager for Command Line.
		pkgs.micro # nano-like text editor for the CLI
		pkgs.tmux # Terminal multiplexer for command line.
		pkgs.tree # ls but as a tree.
	];

	programs.git = {
		enable = true;
		config = {
			user = {
				name = "Patrick Martin";
				email = "patrick.martin.2@outlook.de";
			};
#			safe = {
#				directory = [
#					"/etc/nixos"
#					"/etc/nixos/.git"
#				];
#			};
		};
	};

	# Firewall
	networking.firewall = {
		enable = true;
		# Open ports in the firewall.
		# openssh on 22
		# http and https on 80, 443
		allowedTCPPorts = [ 22 80 443 ];
	};

	system.stateVersion = "24.11";
}
