# docker-dst-mod

[![Docker Image Alpine Size]](https://hub.docker.com/r/viktorpopkov/dst-mod)
[![Docker Image Debian Size]](https://hub.docker.com/r/viktorpopkov/dst-mod)
[![GitHub Workflow CI Status][]](https://github.com/victorpopkov/docker-dst-mod/actions?query=workflow%3ACI)
[![GitHub Workflow Publish Status][]](https://github.com/victorpopkov/docker-dst-mod/actions?query=workflow%3APublish)

## Overview

The mod development environment [Docker][] images for the game
[Don't Starve Together][]. It integrates the corresponding [Lua][] version and
different tools to improve the existing workflow.

- [Lua](#lua)
- [Images & Tools](#images--tools)
- [Environment variables](#environment-variables)
- [Usage](#usage)
  - [Linux](#linux)
  - [Windows](#windows)

## Lua

Even though the latest stable [Lua][] version is 5.4 and, the images bundle the
v5.1.5 to achieving a closer match with the v5.1 interpreter inside the game
engine [Lua][].

## Images & Tools

> If you only need [ktools][] without other tools, then consider using the
> [docker-ktools][] repository instead.

The images bundle the [ktools][] created by [@nsimplex][] and some additional
tools as well.

An [Alpine][] image has been designed mainly for [CI][] purposes. A [Debian][]
image, unlike an [Alpine][] one, has a more complete development environment.

| Tools           | Alpine | Debian |
| --------------- | ------ | ------ |
| Bash completion | -      | Yes    |
| [Busted][]      | Yes    | Yes    |
| [GNU Make][]    | Yes    | Yes    |
| [GNU Wget][]    | -      | Yes    |
| [Git][]         | -      | Yes    |
| [LDoc][]        | Yes    | Yes    |
| [LuaCov][]      | Yes    | Yes    |
| [LuaRocks][]    | Yes    | Yes    |
| [Luacheck][]    | Yes    | Yes    |
| [OpenSSH][]     | -      | Yes    |
| [Prettier][]    | Yes    | Yes    |
| [UnZip][]       | Yes    | Yes    |
| [Vim][]         | -      | Yes    |
| [curl][]        | Yes    | Yes    |
| [krane][]       | Yes    | Yes    |
| [ktech][]       | Yes    | Yes    |
| [rsync][]       | Yes    | Yes    |
| [yarn][]        | Yes    | Yes    |

## Environment variables

| Name                    | Value                  | Description                         |
| ----------------------- | ---------------------- | ----------------------------------- |
| `DS_KTOOLS_KRANE`       | `/usr/local/bin/krane` | Absolute path to the [krane][] tool |
| `DS_KTOOLS_KTECH`       | `/usr/local/bin/ktech` | Absolute path to the [ktech][] tool |
| `DS_KTOOLS_VERSION`     | `4.4.0`                | [ktools][] version                  |
| `DS_MODS` or `DST_MODS` | `/mods/`               | Game mods directory                 |
| `IMAGEMAGICK_VERSION`   | `6.9.11-3`             | [ImageMagick][] version             |
| `LUAROCKS_VERSION`      | `3.3.1`                | [LuaRocks][] version                |
| `LUA_VERSION`           | `5.1.5`                | [Lua][] version                     |

## Usage

First of all, pull the latest [Docker][] image and set your mod directory as the
current one:

```shell script
$ docker pull viktorpopkov/dst-mod
$ cd <your mod directory>
```

### Interactive Shell

```shell script
$ docker run --rm --interactive --tty \
    --mount src='<your mod directory>',target='/mod/',type=bind \
    --mount src='<game mods directory>',target='/mods/',type=bind \ # optional
    --workdir='/mod/' \ # optional
    viktorpopkov/dst-mod
```

### Non-interactive Shell

```shell script
$ docker run --rm \
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
$ docker run --rm -itv "$(pwd):/mod/" viktorpopkov/dst-mod
# or with DST_MODS env
$ docker run --rm -itv "$(pwd):/mod/" -v "${DST_MODS}:/mods/" viktorpopkov/dst-mod
```

##### Non-interactive Shell

```shell script
$ docker run --rm -v "$(pwd):/mod/" viktorpopkov/dst-mod luacheck --version
# or with DST_MODS env
$ docker run --rm -v "$(pwd):/mod/" -v "${DST_MODS}:/mods/" viktorpopkov/dst-mod luacheck --version
```

### Windows

#### CMD

##### Interactive Shell

```cmd
> docker run --rm -itv "%CD%:/mod/" viktorpopkov/dst-mod
```

##### Non-interactive Shell

```cmd
> docker run --rm -v "%CD%:/mod/" viktorpopkov/dst-mod luacheck --version
```

#### PowerShell

You can optionally set the game mods' directory as the `DST_MODS` environment
variable and then mount it if needed:

```powershell
PS:\> $Env:DST_MODS = "C:\Program Files (x86)\Steam\steamapps\common\Don't Starve Together\mods"
```

##### Interactive Shell

```powershell
PS:\> docker run --rm -itv "${PWD}:/mod/" viktorpopkov/dst-mod
# or with DST_MODS env
PS:\> docker run --rm -itv "${PWD}:/mod/" -v "${Env:DST_MODS}:/mods/" viktorpopkov/dst-mod
```

##### Non-interactive Shell

```powershell
PS:\> docker run --rm -v "${PWD}:/mod/" viktorpopkov/dst-mod luacheck --version
# or with DST_MODS env
PS:\> docker run --rm -v "${PWD}:/mod/" -v "${Env:DST_MODS}:/mods/" viktorpopkov/dst-mod luacheck --version
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[@nsimplex]: https://github.com/nsimplex
[alpine]: https://hub.docker.com/_/alpine
[busted]: https://olivinelabs.com/busted/
[ci]: https://en.wikipedia.org/wiki/Continuous_integration
[curl]: https://curl.haxx.se/
[debian]: https://hub.docker.com/_/debian
[docker image alpine size]: https://img.shields.io/docker/image-size/viktorpopkov/dst-mod/debian?label=debian%20size
[docker image debian size]: https://img.shields.io/docker/image-size/viktorpopkov/dst-mod/alpine?label=alpine%20size
[docker-ktools]: https://github.com/victorpopkov/docker-ktools
[docker]: https://www.docker.com/
[don't starve together]: https://www.klei.com/games/dont-starve-together
[git]: https://git-scm.com/
[github workflow ci status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-dst-mod/CI?label=CI
[github workflow publish status]: https://img.shields.io/github/workflow/status/victorpopkov/docker-dst-mod/Publish?label=Publish
[gnu make]: https://www.gnu.org/software/make/
[gnu wget]: https://www.gnu.org/software/wget/
[imagemagick]: https://imagemagick.org/index.php
[krane]: https://github.com/nsimplex/ktools#krane
[ktech]: https://github.com/nsimplex/ktools#ktech
[ktools]: https://github.com/nsimplex/ktools
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
