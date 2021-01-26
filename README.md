# docker-dst-mod

[![Docker Image Alpine Size]](https://hub.docker.com/r/viktorpopkov/dst-mod)
[![Docker Image Debian Size]](https://hub.docker.com/r/viktorpopkov/dst-mod)
[![GitHub Workflow CI Status][]](https://github.com/victorpopkov/docker-dst-mod/actions?query=workflow%3ACI)
[![GitHub Workflow Publish Status][]](https://github.com/victorpopkov/docker-dst-mod/actions?query=workflow%3APublish)

## Overview

The mod development environment [Docker] images for [Don't Starve Together] game
to dive right into the mods' development without bothering with building,
installing and configuring all the tools yourself. Especially comes in handy
when working on Linux.

- [Lua](#lua)
- [Tools](#tools)
- [Environment variables](#environment-variables)
- [Usage](#usage)
  - [Linux](#linux)
  - [Windows](#windows)

## Lua

In order to achieve a closer match with [Lua] interpreter v5.1 bundled in the
game engine, the images bundle v5.1.5 instead of the latest one.

## Tools

> If you only need [ktools][] consider checking [docker-ktools][] instead.

| Tools            | Alpine | Debian |
| ---------------- | ------ | ------ |
| Bash completion  | -      | Yes    |
| [Busted][]       | Yes    | Yes    |
| [CLuaCov][]      | Yes    | Yes    |
| [curl][]         | Yes    | Yes    |
| [ds_mod_tools][] | -      | Yes    |
| [Git][]          | -      | Yes    |
| [GNU Make][]     | Yes    | Yes    |
| [GNU Wget][]     | -      | Yes    |
| [ktools][]       | Yes    | Yes    |
| [LCOV][]         | Yes    | Yes    |
| [LDoc][]         | Yes    | Yes    |
| [Luacheck][]     | Yes    | Yes    |
| [LuaCov][]       | Yes    | Yes    |
| [LuaRocks][]     | Yes    | Yes    |
| [OpenSSH][]      | -      | Yes    |
| [Prettier][]     | Yes    | Yes    |
| [rsync][]        | Yes    | Yes    |
| [UnZip][]        | Yes    | Yes    |
| [Vim][]          | -      | Yes    |
| [yarn][]         | Yes    | Yes    |
| [Zip][]          | Yes    | Yes    |

## Environment Variables

### Alpine & Debian

| Name                    | Value                  | Description                            |
| ----------------------- | ---------------------- | -------------------------------------- |
| `DS_KTOOLS_KRANE`       | `/usr/local/bin/krane` | An absolute path to [ktools][] `krane` |
| `DS_KTOOLS_KTECH`       | `/usr/local/bin/ktech` | An absolute path to [ktools][] `ktech` |
| `DS_KTOOLS_VERSION`     | `4.4.0`                | [ktools][] version                     |
| `DS_MODS` or `DST_MODS` | `/mods`                | Game mods directory                    |
| `IMAGEMAGICK_VERSION`   | `6.9.11-3`             | [ImageMagick][] version                |
| `LUA_VERSION`           | `5.1.5`                | [Lua][] version                        |
| `LUAROCKS_VERSION`      | `3.3.1`                | [LuaRocks][] version                   |

### Debian

| Name                    | Value                 | Description                                         |
| ----------------------- | --------------------- | --------------------------------------------------- |
| `DS_TOOLS_AUTOCOMPILER` | `/tools/autocompiler` | An absolute path to [ds_mod_tools][] `autocompiler` |
| `DS_TOOLS_PNG`          | `/tools/png`          | An absolute path to [ds_mod_tools][] `png`          |
| `DS_TOOLS_SCML`         | `/tools/scml`         | An absolute path to [ds_mod_tools][] `scml`         |

## Usage

First of all, pull the latest [Docker][] image and set your mod directory as the
current one:

```shell script
$ docker pull viktorpopkov/dst-mod
$ cd <your mod directory>
```

### Interactive Shell

```shell script
$ docker run --rm --user='dst-mod' --interactive --tty \
    --mount src='<your mod directory>',target='/mod/',type=bind \
    --mount src='<game mods directory>',target='/mods/',type=bind \ # optional
    --workdir='/mod/' \ # optional
    viktorpopkov/dst-mod
```

### Non-interactive Shell

```shell script
$ docker run --rm --user='dst-mod' \
    --mount src='<your mod directory>',target='/mod/',type=bind \
    --mount src='<game mods directory>',target='/mods/',type=bind \ # optional
    --workdir='/mod/' \ # optional
    viktorpopkov/dst-mod \
    luacheck --version
```

### Linux

#### Bash

You can optionally set the game mods' directory as the `DST_MODS` environment
variable and then mount it if needed:

```shell script
$ export DST_MODS="${HOME}/.steam/steam/steamapps/common/Don't Starve Together/mods/"
```

##### Interactive Shell

```shell script
$ docker run --rm -u 'dst-mod' -itv "$(pwd):/mod/" viktorpopkov/dst-mod
# or with DST_MODS env
$ docker run --rm -u 'dst-mod' -itv "$(pwd):/mod/" -v "${DST_MODS}:/mods/" viktorpopkov/dst-mod
```

##### Non-interactive Shell

```shell script
$ docker run --rm -u 'dst-mod' -v "$(pwd):/mod/" viktorpopkov/dst-mod luacheck --version
# or with DST_MODS env
$ docker run --rm -u 'dst-mod' -v "$(pwd):/mod/" -v "${DST_MODS}:/mods/" viktorpopkov/dst-mod luacheck --version
```

### Windows

#### CMD

##### Interactive Shell

```cmd
C:\> docker run --rm -u 'dst-mod' -itv "%CD%:/mod/" viktorpopkov/dst-mod
```

##### Non-interactive Shell

```cmd
C:\> docker run --rm -u 'dst-mod' -v "%CD%:/mod/" viktorpopkov/dst-mod luacheck --version
```

#### PowerShell

You can optionally set the game mods' directory as the `DST_MODS` environment
variable and then mount it if needed:

```powershell
PS C:\> $Env:DST_MODS = "C:\Program Files (x86)\Steam\steamapps\common\Don't Starve Together\mods"
```

##### Interactive Shell

```powershell
PS C:\> docker run --rm -u 'dst-mod' -itv "${PWD}:/mod/" viktorpopkov/dst-mod
# or with DST_MODS env
PS C:\> docker run --rm -u 'dst-mod' -itv "${PWD}:/mod/" -v "$($Env:DST_MODS):/mods/" viktorpopkov/dst-mod
```

##### Non-interactive Shell

```powershell
PS C:\> docker run --rm -u 'dst-mod' -v "${PWD}:/mod/" viktorpopkov/dst-mod luacheck --version
# or with DST_MODS env
PS C:\> docker run --rm -u 'dst-mod' -v "${PWD}:/mod/" -v "$($Env:DST_MODS):/mods/" viktorpopkov/dst-mod luacheck --version
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[@nsimplex]: https://github.com/nsimplex
[alpine]: https://hub.docker.com/_/alpine
[busted]: https://olivinelabs.com/busted/
[ci]: https://en.wikipedia.org/wiki/Continuous_integration
[cluacov]: https://github.com/mpeterv/cluacov
[curl]: https://curl.haxx.se/
[debian]: https://hub.docker.com/_/debian
[docker image alpine size]: https://img.shields.io/docker/image-size/viktorpopkov/dst-mod/debian?label=debian%20size
[docker image debian size]: https://img.shields.io/docker/image-size/viktorpopkov/dst-mod/alpine?label=alpine%20size
[docker-ktools]: https://github.com/victorpopkov/docker-ktools
[docker]: https://www.docker.com/
[don't starve together]: https://www.klei.com/games/dont-starve-together
[ds_mod_tools]: https://github.com/kleientertainment/ds_mod_tools
[git]: https://git-scm.com/
[github workflow ci status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-dst-mod/CI?label=CI
[github workflow publish status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-dst-mod/Publish?label=Publish
[gnu make]: https://www.gnu.org/software/make/
[gnu wget]: https://www.gnu.org/software/wget/
[imagemagick]: https://imagemagick.org/index.php
[krane]: https://github.com/nsimplex/ktools#krane
[ktech]: https://github.com/nsimplex/ktools#ktech
[ktools]: https://github.com/nsimplex/ktools
[lcov]: http://ltp.sourceforge.net/coverage/lcov.php
[ldoc]: https://stevedonovan.github.io/ldoc/
[lua]: https://www.lua.org/
[luacheck]: https://github.com/mpeterv/luacheck
[luacov]: https://keplerproject.github.io/luacov/
[luarocks]: https://luarocks.org/
[openssh]: https://www.openssh.com/
[prettier]: https://prettier.io/
[rsync]: https://rsync.samba.org/
[unzip]: http://infozip.sourceforge.net/UnZip.html
[vim]: https://www.vim.org/
[yarn]: https://yarnpkg.com/
[zip]: http://infozip.sourceforge.net/Zip.html
