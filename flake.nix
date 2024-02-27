{
  description = "Bad Gateway";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      eachNginx = nixpkgs.lib.genAttrs [ "nginxQuic" "nginxStable" "nginxMainline" ];
      pkgs = import nixpkgs { overlays = [ self.overlays.default ]; };
    in
    {
      packages = eachSystem (_system: eachNginx (nginxAttr: pkgs.${nginxAttr}));

      overlays.default = _final: prev:
        eachNginx (nginxAttr:
          prev.${nginxAttr}.overrideAttrs (attrs: {
            patches = attrs.patches ++ [ ./patches/bad_gateway_nginx_1.25.4.patch ];
          })
        );
    };
}
