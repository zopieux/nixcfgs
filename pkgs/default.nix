self: super: {
  brightness-ddc = super.callPackage ./brightness-ddc.nix { };
  player-mpris-tail = super.callPackage ./player-mpris-tail.nix { };
  rofi-screenshot = super.callPackage ./rofi-screenshot.nix { };
  upscayl = super.callPackage ./upscayl.nix { };
}
