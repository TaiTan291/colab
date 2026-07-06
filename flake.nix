{
  description = "Python 3.13 and uv development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python313
							python313Packages.jupytext
              uv
            ];

            # NixOSが提供するPythonを使用するため、uv自身によるPythonバイナリのダウンロードを無効化
            env = {
              UV_PYTHON_DOWNLOADS = "never";
            };

            shellHook = ''
              echo "Development shell activated"
              echo "Python $(python --version)"
              echo "uv $(uv --version)"
            '';
          };
        });
    };
}
