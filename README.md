# nix-config

this config still requires a users.nix file.
because the root file system is erased on boot, it requires "initialHashedPassword" for each user

to generate the hashed passwords, use
mkpasswd -m sha-512 | sed 's/\$/\\$/g'

in addition, users.mutableUsers must be false
