# docker-dst-mod

[![Alpine Size]](https://hub.docker.com/r/dstmodders/dst-mod)
[![Debian Size]](https://hub.docker.com/r/dstmodders/dst-mod)
[![CI]](https://github.com/dstmodders/docker-dst-mod/actions/workflows/ci.yml)
[![Build]](https://github.com/dstmodders/docker-dst-mod/actions/workflows/build.yml)

## Supported tags and respective `Dockerfile` links

- [`debian`, `latest`](https://github.com/dstmodders/docker-dst-mod/blob/b037f5cc591d41b332b54ca43d92c6d1c929973d/debian/Dockerfile)
- [`alpine`](https://github.com/dstmodders/docker-dst-mod/blob/b037f5cc591d41b332b54ca43d92c6d1c929973d/alpine/Dockerfile)

## Overview

[Docker] images for modding environment of Klei Entertainment's game [Don't
Starve Together] to dive right into the mods' development without bothering with
building, installing and configuring all the tools yourself. Especially comes in
handy when working on Linux and/or macOS.

- [Usage](#usage)
- [Supported tools](#supported-tools)
- [Supported environment variables](#supported-environment-variables)
- [Supported build arguments](#supported-build-arguments)
- [Supported architectures](#supported-architectures)
- [Build](#build)

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
| `DS_KTOOLS_KRANE`       | `/usr/local/bin/krane`  | [ktools/krane] path   |
| `DS_KTOOLS_KTECH`       | `/usr/local/bin/ktech`  | [ktools/ktech] path   |
| `DS_KTOOLS_VERSION`     | `4.5.1`                 | [ktools] version      |
| `DS_MODS` or `DST_MODS` | `/opt/dont_starve/mods` | Mods directory path   |
| `DS` or `DST`           | `/opt/dont_starve`      | Game directory path   |
| `IMAGEMAGICK_VERSION`   | `7.1.1-6`               | [ImageMagick] version |
| `LCOV_VERSION`          | `2.1`                   | [LCOV] version        |
| `LUA_VERSION`           | `5.1.5`                 | [Lua] version         |

### Alpine

| Name               | Value   | Description        |
| ------------------ | ------- | ------------------ |
| `LUAROCKS_VERSION` | `3.8.0` | [LuaRocks] version |

### Debian

| Name                        | Value                                    | Description                    |
| --------------------------- | ---------------------------------------- | ------------------------------ |
| `DS_MOD_TOOLS_AUTOCOMPILER` | `/opt/klei-tools/mod_tools/autocompiler` | [klei-tools/autocompiler] path |
| `DS_MOD_TOOLS_PNG`          | `/opt/klei-tools/mod_tools/png`          | [klei-tools/png] path          |
| `DS_MOD_TOOLS_SCML`         | `/opt/klei-tools/mod_tools/scml`         | [klei-tools/scml] path         |
| `DS_MOD_TOOLS_VERSION`      | `1.0.0`                                  | [klei-tools] version           |
| `DS_MOD_TOOLS`              | `/opt/klei-tools/mod_tools`              | [klei-tools] path              |
| `LUAROCKS_VERSION`          | `3.9.2`                                  | [LuaRocks] version             |
| `STYLUA_VERSION`            | `0.17.1`                                 | [StyLua] version               |

## Supported build arguments

| Name                    | Image    | Default | Description               |
| ----------------------- | -------- | ------- | ------------------------- |
| `DS_KLEI_TOOLS_VERSION` | `debian` | `1.0.0` | Sets [klei-tools] version |
| `DS_KTOOLS_VERSION`     | `alpine` | `4.5.1` | Sets [ktools] version     |

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

[alpine size]: https://img.shields.io/docker/image-size/dstmodders/dst-mod/alpine?label=alpine%20size&logo=docker
[bash-completion]: https://github.com/scop/bash-completion
[build]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-dst-mod/build.yml?branch=main&label=build&logo=github
[busted]: https://olivinelabs.com/busted/
[ci]: https://img.shields.io/github/actions/workflow/status/dstmodders/docker-dst-mod/ci.yml?branch=main&label=ci&logo=github
[cluacov]: https://github.com/mpeterv/cluacov
[curl]: https://curl.haxx.se/
[debian size]: https://img.shields.io/docker/image-size/dstmodders/dst-mod/debian?label=debian%20size&logo=docker
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
