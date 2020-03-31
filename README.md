# docker-dst-mod

## Overview

The mod development environment [Docker][] images for the game
[Don't Starve Together][]. It integrates the corresponding [Lua][] version and
different tools to improve the existing workflow.

-   [Lua](#lua)
-   [Tools](#tools)
-   [Usage](#usage)

## Lua

Even though the latest stable [Lua][] version is 5.3 and even the version 5.4
will be out soon, the images bundle the v5.1.5 to match the game engine [Lua][]
interpreter v5.1.

[LuaRocks][] is integrated as well.

## Tools

The images bundle the [ktools][] created by [nsimplex][]:

-   [krane][]: decompile Klei Entertainment's animation format
-   [ktech][]: convert between Klei Entertainment's TEX texture format and PNG

Furthermore, to encourage following the best practices and improve code quality
they include the following tools as well:

-   [Busted][]
-   [GNU Make][]
-   [LDoc][]
-   [LuaCov][]
-   [Luacheck][]
-   [Prettier][]

Unlike the [Alpine][] image, the main purpose of which is to be as lightweight
as possible, the [Debian][] image has Bash completion and some additional tools
(so you could have a more complete development environment):

-   [GNU Wget][]
-   [Git][]
-   [UnZip][]
-   [Vim][]
-   [curl][]
-   [rsync][]
-   [yarn][]

## Usage

### Interactive Shell

#### Linux

##### Bash

```bash
$ cd <your mod directory>
$ docker pull viktorpopkov/dst-mod:debian
$ docker run --rm --interactive --tty --mount src="$(pwd)",target=/mod/,type=bind --workdir=/mod viktorpopkov/dst-mod:debian
```

#### Windows

##### CMD

```bash
$ cd <your mod directory>
$ docker pull viktorpopkov/dst-mod:debian
$ docker run --rm --interactive --tty --mount src="%CD%",target="/mod/",type=bind --workdir=/mod viktorpopkov/dst-mod:debian
```

##### PowerShell

```bash
$ cd <your mod directory>
$ docker pull viktorpopkov/dst-mod:debian
$ docker run --rm --interactive --tty --mount src="${PWD}",target="/mod/",type=bind --workdir=/mod viktorpopkov/dst-mod:debian
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[alpine]: https://hub.docker.com/_/alpine
[busted]: https://olivinelabs.com/busted/
[curl]: https://curl.haxx.se/
[debian]: https://hub.docker.com/_/debian
[docker]: https://www.docker.com/
[don't starve together]: https://www.klei.com/games/dont-starve-together
[git]: https://git-scm.com/
[gnu make]: https://www.gnu.org/software/make/
[gnu wget]: https://www.gnu.org/software/wget/
[krane]: https://github.com/nsimplex/ktools#krane
[ktech]: https://github.com/nsimplex/ktools#ktech
[ktools]: https://github.com/nsimplex/ktools
[ldoc]: https://stevedonovan.github.io/ldoc/
[lua]: https://www.lua.org/
[luacheck]: https://github.com/mpeterv/luacheck
[luacov]: https://keplerproject.github.io/luacov/
[luarocks]: https://luarocks.org/
[nsimplex]: https://github.com/nsimplex
[prettier]: https://prettier.io/
[rsync]: https://rsync.samba.org/
[unzip]: http://infozip.sourceforge.net/UnZip.html
[vim]: https://www.vim.org/
[yarn]: https://yarnpkg.com/
