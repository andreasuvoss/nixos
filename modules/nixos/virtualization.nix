{ pkgs, lib, config, ... }: {
  options = {
    virtualization.enable = lib.mkEnableOption "enables virtualization";
  };
  config = lib.mkIf config.virtualization.enable {
    virtualisation.libvirtd.enable = true;
    virtualisation.podman.enable = true;
    services.spice-vdagentd.enable = true;
    programs.virt-manager.enable = true;
  };
}
