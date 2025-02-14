{ lib, pkgs, config, ... }: {
  imports = [ 
    ./kmod.nix
    ../../common/cpu/intel/alder-lake
   ];

  services.fprintd.enable = lib.mkDefault true;
  hardware.samsung-galaxybook.enable = lib.mkDefault true;
  boot.kernelParams = [ "i915.enable_dpcd_backlight=3" ];

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
