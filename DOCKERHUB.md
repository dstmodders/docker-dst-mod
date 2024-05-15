## Supported tags and respective `Dockerfile` links

- [`debian`, `latest`](https://github.com/dstmodders/docker-dst-mod/blob/b037f5cc591d41b332b54ca43d92c6d1c929973d/debian/Dockerfile)
- [`alpine`](https://github.com/dstmodders/docker-dst-mod/blob/b037f5cc591d41b332b54ca43d92c6d1c929973d/alpine/Dockerfile)

## Overview

[Docker] images for modding environment of Klei Entertainment's game [Don't
Starve Together] to dive right into the mods' development without bothering with
building, installing and configuring all the tools yourself. Especially comes in
handy when working on Linux and/or macOS.

- [Usage](https://github.com/dstmodders/docker-dst-mod/blob/main/README.md#usage)
- [Supported tools](https://github.com/dstmodders/docker-dst-mod/blob/main/README.md#supported-tools)
- [Supported environment variables](https://github.com/dstmodders/docker-dst-mod/blob/main/README.md#supported-environment-variables)
- [Supported build arguments](https://github.com/dstmodders/docker-dst-mod/blob/main/README.md#supported-build-arguments)
- [Supported architectures](https://github.com/dstmodders/docker-dst-mod/blob/main/README.md#supported-architectures)
- [Build](https://github.com/dstmodders/docker-dst-mod/blob/main/README.md#build)

## Usage

```shell
$ docker pull dstmodders/dst-mod:latest
# or
$ docker pull ghcr.io/dstmodders/dst-mod:latest
```

See [tags] for a list of all available versions.

In the examples below, the current working directory will be mounted to the
container as your mod directory.

#### Shell/Bash (Linux & macOS)

```shell
$ docker run --rm -it \
    -v "$(pwd):/opt/dont_starve/mods/$(basename "$(pwd)")" \
    -w "/opt/dont_starve/mods/$(basename "$(pwd)")" \
    dstmodders/dst-mod \
    /bin/bash
```

#### CMD (Windows)

```cmd
> for %I in (.) do docker run --rm -it ^
    -v "%CD%:/opt/dont_starve/mods/%~nxI" ^
    -w "/opt/dont_starve/mods/%~nxI" ^
    dstmodders/dst-mod ^
    /bin/bash
```

#### PowerShell (Windows)

```powershell
PS:\> docker run --rm -it `
    -v "${PWD}:/opt/dont_starve/mods/$((Get-Item "${PWD}").Basename)" `
    -w "/opt/dont_starve/mods/$((Get-Item "${PWD}").Basename)" `
    dstmodders/dst-mod `
    /bin/bash
```

## Supported tools

> [!NOTE]
> Since the game engine bundles [Lua] interpreter v5.1, the images bundle v5.1.5
> instead of the latest one.

|                    | Alpine                                                                        | Debian                                                                                                                                  |
| ------------------ | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Packages           | [curl]<br />[GNU Make]<br />[GNU Wget]<br />[rsync]<br />[UnZip]<br />[Zip]   | [curl]<br />[Git]<br />[GNU Make]<br />[GNU Wget]<br />[bash-completion]<br />[OpenSSH]<br />[rsync]<br />[UnZip]<br />[Vim]<br />[Zip] |
| [Lua] + [LuaRocks] | [Busted]<br />[CLuaCov]<br />[LCOV]<br />[LDoc]<br />[Luacheck]<br />[LuaCov] | [Busted]<br />[CLuaCov]<br />[LCOV]<br />[LDoc]<br />[Luacheck]<br />[LuaCov]                                                           |
| [NodeJS]           | [Prettier]<br />[yarn]                                                        | [Prettier]<br />[yarn]                                                                                                                  |
| Other              | [ktools]                                                                      | [klei-tools]<br />[ktools]<br />[StyLua]                                                                                                |

## Supported environment variables

### General

| Name                    | Value                   | Description           |
| ----------------------- | ----------------------- | --------------------- |
| `DS_MODS` or `DST_MODS` | `/opt/dont_starve/mods` | Mods directory path   |
| `DS` or `DST`           | `/opt/dont_starve`      | Game directory path   |
| `IMAGEMAGICK_VERSION`   | `7.1.1-32`              | [ImageMagick] version |
| `KTOOLS_KRANE`          | `/usr/local/bin/krane`  | [ktools/krane] path   |
| `KTOOLS_KTECH`          | `/usr/local/bin/ktech`  | [ktools/ktech] path   |
| `KTOOLS_VERSION`        | `4.5.1`                 | [ktools] version      |
| `LCOV_VERSION`          | `2.1`                   | [LCOV] version        |
| `LUA_VERSION`           | `5.1.5`                 | [Lua] version         |

### Alpine

| Name               | Value   | Description        |
| ------------------ | ------- | ------------------ |
| `LUAROCKS_VERSION` | `3.8.0` | [LuaRocks] version |

### Debian

| Name                      | Value                                    | Description                    |
| ------------------------- | ---------------------------------------- | ------------------------------ |
| `KLEI_TOOLS_AUTOCOMPILER` | `/opt/klei-tools/mod_tools/autocompiler` | [klei-tools/autocompiler] path |
| `KLEI_TOOLS_PNG`          | `/opt/klei-tools/mod_tools/png`          | [klei-tools/png] path          |
| `KLEI_TOOLS_SCML`         | `/opt/klei-tools/mod_tools/scml`         | [klei-tools/scml] path         |
| `KLEI_TOOLS_VERSION`      | `1.0.0`                                  | [klei-tools] version           |
| `LUAROCKS_VERSION`        | `3.11.0`                                 | [LuaRocks] version             |
| `STYLUA_VERSION`          | `0.20.0`                                 | [StyLua] version               |

## Supported build arguments

| Name                  | Image                  | Default    | Description                |
| --------------------- | ---------------------- | ---------- | -------------------------- |
| `IMAGEMAGICK_VERSION` | `alpine`               | `7.1.1-32` | Sets [ImageMagick] version |
| `KLEI_TOOLS_VERSION`  | `debian`               | `1.0.0`    | Sets [klei-tools] version  |
| `KTOOLS_VERSION`      | `alpine`<br />`debian` | `4.5.1`    | Sets [ktools] version      |

## Supported architectures

| Image    | Architecture(s) |
| -------- | --------------- |
| `alpine` | `linux/amd64`   |
| `debian` | `linux/amd64`   |

## Build

To build images locally:

```shell
$ docker build --tag='dstmodders/dst-mod:alpine' ./alpine/
$ docker build --tag='dstmodders/dst-mod:debian' ./debian/
```

Respectively, to build multi-platform images using [buildx]:

```shell
$ docker buildx build --platform='linux/amd64' --tag='dstmodders/dst-mod:alpine' ./alpine/
$ docker buildx build --platform='linux/amd64' --tag='dstmodders/dst-mod:debian' ./debian/
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[bash-completion]: https://github.com/scop/bash-completion
[busted]: https://olivinelabs.com/busted/
[cluacov]: https://github.com/mpeterv/cluacov
[curl]: https://curl.haxx.se/
[docker]: https://www.docker.com/
[git]: https://git-scm.com/
[gnu make]: https://www.gnu.org/software/make/
[gnu wget]: https://www.gnu.org/software/wget/
[imagemagick]: https://imagemagick.org/index.php
[klei-tools/autocompiler]: https://github.com/dstmodders/klei-tools?tab=readme-ov-file#autocompiler
[klei-tools/png]: https://github.com/dstmodders/klei-tools?tab=readme-ov-file#png
[klei-tools/scml]: https://github.com/dstmodders/klei-tools?tab=readme-ov-file#scml
[klei-tools]: https://github.com/dstmodders/klei-tools
[ktools/krane]: https://github.com/dstmodders/ktools?tab=readme-ov-file#krane
[ktools/ktech]: https://github.com/dstmodders/ktools?tab=readme-ov-file#ktech
[ktools]: https://github.com/dstmodders/ktools
[lcov]: http://ltp.sourceforge.net/coverage/lcov.php
[ldoc]: https://stevedonovan.github.io/ldoc/
[lua]: https://www.lua.org/
[luacheck]: https://github.com/mpeterv/luacheck
[luacov]: https://keplerproject.github.io/luacov/
[luarocks]: https://luarocks.org/
[nodejs]: https://nodejs.org/
[openssh]: https://www.openssh.com/
[prettier]: https://prettier.io/
[rsync]: https://rsync.samba.org/
[stylua]: https://github.com/JohnnyMorganz/StyLua
[tags]: https://hub.docker.com/r/dstmodders/dst-mod/tags
[unzip]: http://infozip.sourceforge.net/UnZip.html
[vim]: https://www.vim.org/
[yarn]: https://yarnpkg.com/
[zip]: http://infozip.sourceforge.net/Zip.html
