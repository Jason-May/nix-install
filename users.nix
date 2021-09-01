{ pkgs, lib, ... }
{
  # generate hashed password with <mkpasswd -m sha-512 | sed 's/\$/\\$/g'>
  users = {
    mutableUsers = false;
    users.root = {
      initialHashedPassword = "<hashed-password>";
    };
    users.jason = {
      initialHashedPassword = "<hashed-password>";
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };
}
