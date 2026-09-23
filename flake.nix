{
  description = "ferns-personal-wallpaper-collection";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    systems.url = "github:nix-systems/default";
  };

  # outputs = inputs: {
  #   packages = builtins.mapAttrs (system: pkgs: {
  #     hello = pkgs.hello;
  #
  #     default = inputs.self.packages.${system}.hello;
  #   }) inputs.nixpkgs.legacyPackages;
  # };
  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      genSystems = lib.genAttrs (import systems);
      pkgsFor = nixpkgs.legacyPackages;
      version = self.shortRev or "dirty";
    in
    {
      overlays.default = _: prev: {
        full = prev.callPackage ./pkgs/full.nix {
          inherit version inputs;
        };
      };

      packages = genSystems (
        system:
        (self.overlays.default null pkgsFor.${system})
        // {
          default = self.packages.${system}.full;
        }
      );
    };
}
