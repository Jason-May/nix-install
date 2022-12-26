# nix-config
useful articles for setup

erase your darlings
https://grahamc.com/blog/erase-your-darlings

erase your darlings script
https://gist.github.com/mx00s/ea2462a3fe6fdaa65692fe7ee824de3e
https://gist.github.com/Jason-May/f33b922c3fdd756dd09135561cb7f573

tmpfs as root
https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/

home manager tutorial
https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix

startup optimization:
https://majiehong.com/post/2021-07-30_slow_nixos_startup/

laptop additional stuff:
https://huijzer.xyz/posts/nixos-laptop/

password gen

this config still requires a users.nix file.
because the root file system is erased on boot, it requires "initialHashedPassword" for each user

to generate the hashed passwords, use
mkpasswd -m sha-512 | sed 's/\$/\\$/g'

in addition, users.mutableUsers must be false
