{ pkgs, lib, config, ... }: {
  options = {
    virtualization.enable = lib.mkEnableOption "enables virtualization";
  };
  config = lib.mkIf config.virtualization.enable {
    environment.systemPackages = with pkgs; [
      virtiofsd
    ];
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
    virtualisation.podman.enable = true;
    virtualisation.docker.enable = true;
    services.spice-vdagentd.enable = true;
    programs.virt-manager.enable = true;
  };
}
