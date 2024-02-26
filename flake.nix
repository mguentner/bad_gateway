{
  description = "Bad Gateway";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.nginxQuic =
      nixpkgs.legacyPackages.x86_64-linux.nginxQuic.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ./patches/bad_gateway_nginx_1.25.4.patch ];
      });
    packages.x86_64-linux.nginxStable =
      nixpkgs.legacyPackages.x86_64-linux.nginxStable.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ./patches/bad_gateway_nginx_1.25.4.patch ];
      });
    packages.x86_64-linux.nginxMainline =
      nixpkgs.legacyPackages.x86_64-linux.nginxMainline.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ./patches/bad_gateway_nginx_1.25.4.patch ];
      });
    packages.x86_64-linux.default = self.packages.x86_64-linux.nginxStable;

    overlays.default = final: prev: {
      nginxQuic = prev.nginxQuic.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ./patches/bad_gateway_nginx_1.25.4.patch ];
      });
      nginxStable = prev.nginxStable.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ./patches/bad_gateway_nginx_1.25.4.patch ];
      });
      nginxMainline = prev.nginxMainline.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ./patches/bad_gateway_nginx_1.25.4.patch ];
      });
    };
  };
}
