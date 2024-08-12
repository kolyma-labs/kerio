{
  description = "Kerio connnect for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=24.05";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system}.default = self.packages.x86_64-linux.kerio;

    packages.${system}.kerio = pkgs.stdenv.mkDerivation rec {
        pname = "kerio-control-vpnclient";
        version = "9.4.2.7290";

        src = pkgs.fetchurl {
          url = "https://cdn.kerio.com/dwn/control/control-${version}-${version}/kerio-control-vpnclient-${version%.*}-${version}-p1-linux-amd64.deb";
          sha256 = "019e015b72196b5e16c26ff6f2b365b0ddefd158520fbbd0a30a738ca7061b41";
        };

        nativeBuildInputs = [ pkgs.libarchive ];

        buildInputs = [ pkgs.procps pkgs.dialog pkgs.util-linux pkgs.libxcrypt_compat ];

        installPhase = ''
          bsdtar -xf $src -C $out

          install -m 755 -d $out/usr/bin
          install -m 755 -t $out/usr/bin $out/usr/sbin/kvpncsvc

          # Install the main binary

          # Install additional libraries
          install -m 755 -d $out/usr/lib/${pname}
          install -m 755 -t $out/usr/lib/${pname} $out/usr/lib/*

          # Install documentation
          install -m 755 -d $out/usr/share/doc/${pname}
          install -m 644 -t $out/usr/share/doc/${pname} $out/usr/share/doc/${pname}/Acknowledgments.gz
          install -m 644 -t $out/usr/share/doc/${pname} $out/usr/share/doc/${pname}/copyright

          # Install configuration file
          install -m 644 ${./kvpnc.conf} $out/etc/conf.d/kvpnc.conf

          # Install systemd service
          install -m 644 ${./kvpnc.service} $out/usr/lib/systemd/system/kvpnc.service

          # Install license file
          gzip -dfc $out/usr/share/doc/${pname}/EULA.txt.gz > $out/usr/share/licenses/${pname}/EULA.txt
            '';

        meta = with pkgs.lib; {
          description = "Kerio Control VPN client for corporate networks.";
          homepage = "http://www.kerio.com/control";
          license = licenses.unfreeRedistributable;
          platforms = platforms.linux;
          maintainers = with maintainers; [ yourname ];
        };
    };
  };
}
