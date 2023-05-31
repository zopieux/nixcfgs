self: super: {
  player-mpris-tail = super.callPackage ./player-mpris-tail.nix { };
  brightness-ddc = super.callPackage ./brightness-ddc.nix { };
  upscayl = super.callPackage ./upscayl.nix { };
}
