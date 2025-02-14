{ lib, pkgs, config, ... }: {
  imports = [ ../../common/cpu/intel/alder-lake ];

  boot.kernelParams = [ "i915.enable_dpcd_backlight=3" ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];


  services.fprintd.enable = lib.mkDefault true;
  
  ###
  # Kernel module by Joshua Grisham, added features in readme
  # https://github.com/joshuagrisham/samsung-galaxybook-extras
  # deactivate with:
  # hardware.samsung-galaxybook.enable =  false;
  # 

  options = {
    hardware.samsung-galaxybook.enable =
      lib.mkEnableOption "Samsung Galaxybook extras" { default = true; };
  };
  config = lib.mkIf config.hardware.samsung-galaxybook.enable {
    boot.extraModulePackages = [
      (pkgs.callPackage ./kmod.nix {
        kernel = config.boot.kernelPackages.kernel;
      })
    ];
    boot.kernelModules = [ "samsung-galaxybook" ];
  };

}
