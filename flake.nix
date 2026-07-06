{
  description = "Python 3.13 and uv development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      # flake-parts のモジュールとして treefmt-nix をインポート
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { pkgs, ... }: {
        # treefmt-nix の設定
        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            ruff.format = true;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python313
            python313Packages.jupytext
            uv
            # config を経由せず、pkgs の仕組みから直接 treefmt を参照
            treefmt
          ];

          env = {
            UV_PYTHON_DOWNLOADS = "never";
          };

          shellHook = ''
            echo "Development shell activated"
            echo "Python $(python --version)"
            echo "uv $(uv --version)"
          '';
        };
      };
    };
}
