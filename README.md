# docker-dst-mod

[![Alpine Size](https://img.shields.io/docker/image-size/viktorpopkov/dst-mod/alpine?label=alpine%20size)](https://hub.docker.com/r/viktorpopkov/dst-mod)
[![Debian Size](https://img.shields.io/docker/image-size/viktorpopkov/dst-mod/debian?label=debian%20size)](https://hub.docker.com/r/viktorpopkov/dst-mod)
[![CI](https://img.shields.io/github/workflow/status/victorpopkov/docker-dst-mod/CI?label=CI)](https://github.com/victorpopkov/docker-dst-mod/actions?query=workflow%3ACI)

## Overview

[Docker][] images for modding environment of Klei Entertainment's game
[Don't Starve Together][] to dive right into the mods' development without
bothering with building, installing and configuring all the tools yourself.
Especially comes in handy when working on Linux and/or macOS.

- [Environment variables](#environment-variables)
- [Tools](#tools)
- [Usage](#usage)
  - [Linux & macOS](#linux--macos)
  - [Windows](#windows)

## Environment variables

### Alpine & Debian

| Name                    | Value                   | Description                |
| ----------------------- | ----------------------- | -------------------------- |
| `DS_KTOOLS_KRANE`       | `/usr/local/bin/krane`  | Path to [ktools][] `krane` |
| `DS_KTOOLS_KTECH`       | `/usr/local/bin/ktech`  | Path to [ktools][] `ktech` |
| `DS_KTOOLS_VERSION`     | `4.5.0`                 | [ktools][] version         |
| `DS_MODS` or `DST_MODS` | `/opt/dont_starve/mods` | Path to the mods directory |
| `DS` or `DST`           | `/opt/dont_starve`      | Path to the game directory |
| `IMAGEMAGICK_VERSION`   | `7.1.0-5`               | [ImageMagick][] version    |
| `LCOV_VERSION`          | `1.15`                  | [LCOV] version             |
| `LUA_VERSION`           | `5.1.5`                 | [Lua][] version            |
| `LUAROCKS_VERSION`      | `3.7.0`                 | [LuaRocks][] version       |

### Debian

| Name                        | Value                                      | Description              |
| --------------------------- | ------------------------------------------ | ------------------------ |
| `DS_MOD_TOOLS_AUTOCOMPILER` | `/opt/ds-mod-tools/mod_tools/autocompiler` | Path to `autocompiler`   |
| `DS_MOD_TOOLS_PNG`          | `/opt/ds-mod-tools/mod_tools/png`          | Path to `png`            |
| `DS_MOD_TOOLS_SCML`         | `/opt/ds-mod-tools/mod_tools/scml`         | Path to `scml`           |
| `DS_MOD_TOOLS_VERSION`      | `1.0.0`                                    | [ds-mod-tools][] version |
| `DS_MOD_TOOLS`              | `/opt/ds-mod-tools/mod_tools`              | Path to [ds-mod-tools][] |

## Tools

> Since the game engine bundles [Lua] interpreter v5.1, the images bundle v5.1.5
> instead of the latest one.

|                      | Alpine                                                                          | Debian                                                                                                                                    |
| -------------------- | ------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Packages             | [curl][]<br>[GNU Make][]<br>[GNU Wget][]<br>[rsync][]<br>[UnZip][]<br>[Zip][]   | [curl][]<br>[Git][]<br>[GNU Make][]<br>[GNU Wget][]<br>[bash-completion][]<br>[OpenSSH][]<br>[rsync][]<br>[UnZip][]<br>[Vim][]<br>[Zip][] |
| [Lua] + [LuaRocks][] | [Busted][]<br>[CLuaCov][]<br>[LCOV][]<br>[LDoc][]<br>[Luacheck][]<br>[LuaCov][] | [Busted][]<br>[CLuaCov][]<br>[LCOV][]<br>[LDoc][]<br>[Luacheck][]<br>[LuaCov][]                                                           |
| [NodeJS][]           | [Prettier][]<br>[yarn][]                                                        | [Prettier][]<br>[yarn][]                                                                                                                  |
| Other                | [ktools][]                                                                      | [ds-mod-tools][]<br>[ktools][]                                                                                                            |

## Usage

```shell
$ docker pull viktorpopkov/dst-mod
```

See [tags][] for a list of all available versions.

### Interactive

```shell
$ docker run --rm --user='dst-mod' --interactive --tty \
    --mount src='/path/to/your/mod/',target='/opt/dont_starve/mods/<your mod name>/',type=bind \
    --workdir='/opt/dont_starve/mods/<your mod name>/' \
    viktorpopkov/dst-mod \
    /bin/bash
```

The same, but shorter:

```shell
$ docker run --rm -itu dst-mod \
    -v '/path/to/your/mod/:/opt/dont_starve/mods/<your mod name>/' \
    -w '/opt/dont_starve/mods/<your mod name>/' \
    viktorpopkov/dst-mod \
    /bin/bash
```

### Non-interactive

```shell
$ docker run --rm --user='dst-mod' \
    --mount src='/path/to/your/mod/',target='/opt/dont_starve/mods/<your mod name>/',type=bind \
    --workdir='/opt/dont_starve/mods/<your mod name>/' \
    viktorpopkov/dst-mod
```

The same, but shorter:

```shell
$ docker run --rm -u dst-mod \
    -v '/path/to/your/mod/:/opt/dont_starve/mods/<your mod name>/' \
    -w '/opt/dont_starve/mods/<your mod name>/' \
    viktorpopkov/dst-mod
```

### Linux & macOS

#### Shell/Bash

```shell
$ docker run --rm -itu dst-mod \
    -v "$(pwd):/opt/dont_starve/mods/$(basename $(pwd))" \
    -w "/opt/dont_starve/mods/$(basename $(pwd))" \
    viktorpopkov/dst-mod \
    /bin/bash
```

### Windows

#### CMD

```cmd
C:\> docker run --rm -itu dst-mod ^
    -v "%CD%:/opt/dont_starve/mods/<your mod name>/" ^
    -w "/opt/dont_starve/mods/<your mod name>/" ^
    viktorpopkov/dst-mod ^
    /bin/bash
```

#### PowerShell

```powershell
PS C:\> $basename = (Get-Item "${PWD}").Basename; docker run --rm -itu dst-mod `
    -v "${PWD}:/opt/dont_starve/mods/${basename}/" `
    -w "/opt/dont_starve/mods/${basename})" `
    viktorpopkov/dst-mod `
    /bin/bash
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[bash-completion]: https://github.com/scop/bash-completion
[busted]: https://olivinelabs.com/busted/
[cluacov]: https://github.com/mpeterv/cluacov
[curl]: https://curl.haxx.se/
[docker]: https://www.docker.com/
[don't starve together]: https://www.klei.com/games/dont-starve-together
[ds-mod-tools]: https://github.com/victorpopkov/ds-mod-tools
[git]: https://git-scm.com/
[gnu make]: https://www.gnu.org/software/make/
[gnu wget]: https://www.gnu.org/software/wget/
[imagemagick]: https://imagemagick.org/index.php
[krane]: https://github.com/victorpopkov/ktools#krane
[ktech]: https://github.com/victorpopkov/ktools#ktech
[ktools]: https://github.com/victorpopkov/ktools
[lcov]: http://ltp.sourceforge.net/coverage/lcov.php
[ldoc]: https://stevedonovan.github.io/ldoc/
[lua]: https://www.lua.org/
[luacheck]: https://github.com/mpeterv/luacheck
[luacov]: https://keplerproject.github.io/luacov/
[luarocks]: https://luarocks.org/
[openssh]: https://www.openssh.com/
[prettier]: https://prettier.io/
[rsync]: https://rsync.samba.org/
[tags]: https://hub.docker.com/r/viktorpopkov/dst-mod/tags
[unzip]: http://infozip.sourceforge.net/UnZip.html
[vim]: https://www.vim.org/
[yarn]: https://yarnpkg.com/
[zip]: http://infozip.sourceforge.net/Zip.html
