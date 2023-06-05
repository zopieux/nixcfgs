{ config, lib, pkgs, ... }:

let cfg = config.my.roles.ipfs;
in {
  options = { my.roles.ipfs.enable = lib.mkEnableOption "IPFS gateway"; };

  config = lib.mkIf cfg.enable {
    users.users."alex".extraGroups = [ config.services.kubo.group ];
    services.kubo = {
      enable = true;
      startWhenNeeded = true;
      enableGC = true;
      autoMount = true;
      settings.Addresses.API = "/ip4/127.0.0.1/tcp/4002";
      settings.Addresses.Gateway = "/ip4/127.0.0.1/tcp/4003";
      settings.Datastore.StorageMax = "5GB";
      settings.Swarm.ResourceMgr.MaxMemory = "5GB";
      settings.API.HTTPHeaders.Access-Control-Allow-Origin =
        [ "http://localhost:4002" "https://webui.ipfs.io" ];
      settings.API.HTTPHeaders.Access-Control-Allow-Methods = [ "POST" ];
    };
  };
}
