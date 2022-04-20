# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{  

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

hardware.bluetooth.enable = true; 

security.pam.services.kwallet = {
  name = "kwallet";
  enableKwallet = false;
};

  virtualisation.docker.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
	  # boot.loader.systemd-boot.enable = true;
	  efi.canTouchEfiVariables = true;
	  grub.enable = true;
	  grub.devices = [ "nodev" ];
	  grub.efiSupport = true;
	  grub.useOSProber = true;
  };
  
  boot.blacklistedKernelModules = [ "snd_pcsp" ]; # Disable PC Speaker "audio card"
  
  
  networking = {

# Define your hostname.
    hostName = "nixos-gurylev";
	
	networkmanager = {
#		unmanaged = [ "*" "except:type:wwan" "except:type:gsm" ];
		enable = true; 
	};

	# Enables wireless support via wpa_supplicant.
    wireless = {
      enable = false;
      interfaces = ["wlp1s0"];
      userControlled.enable = true;
      userControlled.group = "network";
      networks = {
        "RT-WiFi-92B2" = {
          psk = "x4tDupKE";
        };
		"RT-5WiFi-92B2" = {
	  	  psk = "cQ6nc3YU";
		};
		"RZIAS" = {
          psk = "iloverza32167";
        };
      };
    }; 

 # The global useDHCP flag is deprecated, therefore explicitly set to false here.
     useDHCP = false;

# Per-interface useDHCP will be mandatory in the future, so this generated config
# replicates the default behaviour.
     interfaces.wlp0s20f3.useDHCP = false; 
  };

  # Set your time zone.
   time.timeZone = "Europe/Moscow";


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


services.xserver = {
# Enable the X11 windowing system.
  enable = true;
  autorun = false;

  videoDrivers = [ "modesetting" ];
  useGlamor = true;
  desktopManager.plasma5.enable = true;
#  synaptics.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
  libinput.enable = true;
  libinput.touchpad.naturalScrolling = false;
  libinput.touchpad.middleEmulation = true;
  libinput.touchpad.tapping = true;

# Configure keymap in X11
  layout = "us,ru";
  xkbOptions = "grp:alt_shift_toggle";
};
      
# Enable the GNOME Desktop Environment.
#  services.xserver.displayManager.gdm.enable = false;
#  services.xserver.desktopManager.gnome.enable = false;
  

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

   systemd.packages = [ pkgs.packagekit pkgs.earlyoom ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gur = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
   };     
   
   # pkgs.ksnip.enable = false;
      
   containers.temp-pg.config.services.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
    ## set a custom new dataDir
    # dataDir = "/some/data/dir";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	acpi
	anydesk
	clang
	cmake
	jetbrains.clion
	dhcpcd	
	discord
	dmidecode
	docker
	docker-compose
	earlyoom
	emacs
	foxitreader
	git
	google-chrome
	htop
	i2c-tools
	jetbrains.pycharm-community
	jetbrains.idea-ultimate
	jetbrains.jdk
	killall
  	ksnip
	mongodb
	nodejs
	nodejs-14_x
	nodejs-16_x
	nodejs-17_x
	nodePackages.typescript
	networkmanagerapplet	
	notepadqq
	openjdk
	openvpn
	postgresql
	postman
	pkg-config
	pkgs.postgresql
	pulseaudio
	racket
	rar
	skypeforlinux
	tdesktop
  	tdlib
	tlp
	unrar
	unzip
  	visualvm
	whatsapp-for-linux
	wine
	wpa_supplicant
	wpsoffice
	yandex-disk 
	zip
  # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
   ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services = {
     # postgresql.enable = true;
     # postgresql.package = pkgs.postgresql_11;
      
      tlp.enable = true;
	  blueman.enable = true;
      
      earlyoom.enable = true;
	#  earlyoom.freeMemThreshold = 1;
	 # earlyoom.enableNotifications = true;
  };
  
	systemd.services.earlyoom.serviceConfig.ExecStart = lib.mkForce [    	
    	"${pkgs.earlyoom}/bin/earlyoom -m 1 --avoid (java|google)"
	];
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  
  system.autoUpgrade.enable = true;
  system.stateVersion = "22.05"; # Did you read the comment?

}



