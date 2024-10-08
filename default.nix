{ pkgs ? import <nixpkgs> { }, ... }:
let
  lib = pkgs.lib;
in
pkgs.stdenv.mkDerivation rec {
  pname = "kerio-control-vpnclient";
  version = "9.4.4-8434";

  src = pkgs.fetchurl {
    url = "https://cdn.kerio.com/dwn/control/control-${version}/${pname}-${version}-linux-amd64.deb";
    # sha256sum kerio-control-vpnclient-9.4.4-8434-linux-amd64.deb
    # nix hash to-sri --type sha256 ad04c68c2af9928534ea769f2bf2d6aa7784742d24658616c1399407b31783f8
    hash = "sha256-rQTGjCr5koU06nafK/LWqneEdC0kZYYWwTmUB7MXg/g=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
  ];

  buildInputs = [
  ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out/

    ls -la

    mkdir -p $out/bin/
    cp usr/sbin/kvpncsvc $out/bin/kvpncsvc
    cp usr/sbin/kvpncsvc $out/bin/kerio-control-vpnclient
  '';

  meta = with lib; {
    homepage = "http://www.kerio.com/control";
    description = "Kerio Control VPN client for corporate networks.";
    licencse = licenses.mit;
    platforms = with platforms; linux;

    maintainers = [
      {
        name = "Sokhibjon Orzikulov";
        email = "sakhib@orzklv.uz";
        handle = "orzklv";
        github = "orzklv";
        githubId = 54666588;
        keys = [{
          fingerprint = "00D2 7BC6 8707 0683 FBB9  137C 3C35 D3AF 0DA1 D6A8";
        }];
      }
    ];
  };
}
