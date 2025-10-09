# hetznerwpvps nixos config

## Current Setup

IPv4 is `91.98.46.34`.
Using `worldpower` keyfile to login to user `patrick`.

## Installation on new VPS

Use `nixos-anywhere`:
1. Create the lock file using `nix flake lock`.
2. Make sure to have passwordless root access, so set up a ssh-keyfile and change the ssh config file.
3. use
```
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ~/hetznerwpvpsNixosConfig/hardware-configuration.nix --flake ~/hetznerwpvpsNixosConfig#hetznerwpvps --target-host root@hetznerwpvps
```
