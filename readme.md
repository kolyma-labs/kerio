<p align="center">
    <img src=".github/assets/header.png" alt="Kolyma's {Kerio}">
</p>

<p align="center">
    <h3 align="center">Kerio wrap-up for NixOS.</h3>
</p>

<p align="center">
    <img align="center" src="https://img.shields.io/github/languages/top/kolyma-labs/kerio?style=flat&logo=nixos&logoColor=ffffff&labelColor=242424&color=242424" alt="Top Used Language">
    <a href="https://github.com/kolyma-labs/kerio/actions/workflows/test.yml"><img align="center" src="https://img.shields.io/github/actions/workflow/status/kolyma-labs/kerio/test.yml?style=flat&logo=github&logoColor=ffffff&labelColor=242424&color=242424" alt="Test CI"></a>
</p>

## About

A company where the maintainer works require its workers to use Kerio Connect to access servers via ssh. Therefore, creating Kerio Connect
port for NixOS was necessary.

> Using Kerio in company should be illegal && crime!

## Features

- Reproducible Kerio Connect configurations
- Makes use of 24.05

## Running package

You can run the package by using the following command:

```shell
nix run github:kolyma-labs/kerio --impure
```

## Installing package

You should add this repository to your config flake inputs:

```nix
# Kerio Control Access
kerio = {
  url = "github:kolyma-labs/kerio";
  inputs.nixpkgs.follows = "nixpkgs";
  flake = true;
};
```


Then, modify your `pkgs` instance to include `kerio` package by adding overlay:

```nix
# Bind the kerio packages over pkgs.kerio
kerio-additions = final: _prev: {
  kerio = import inputs.kerio {
    system = final.system;
    config.allowUnfree = true;
  };
};
```

Finally, you can include kerio in your global system packages:

```nix
# Adding kerio control vpn
environment.systemPackages = [
  pkgs.kerio # .kerio-control-vpnclient
];
```

## Thanks

- [Tony Finn](https://tonyfinn.com/blog/arch-packages-with-nix/) - For awesome tutorial on converting arch package to nix
- [Nix](https://nixos.org/) - Masterpiece of package management

## License

This project is licensed under the MIT License - see the [LICENSE](license) file for details.

<p align="center">
    <img src=".github/assets/footer.png" alt="Kolyma's {Kerio}">
</p>
