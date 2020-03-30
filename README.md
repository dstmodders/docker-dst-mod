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

[LuaRocks][] is bundled as well.

## Tools

The images bundle the [ktools][] created by [nsimplex][]:

-   [krane][]: decompile Klei Entertainment's animation format
-   [ktech][]: convert between Klei Entertainment's TEX texture format and PNG

Also, to encourage following the best practices and improve code quality the
following tools are bundled as well:

-   [Busted][]
-   [GNU Make][]
-   [LDoc][]
-   [LuaCov][]
-   [Luacheck][]
-   [Prettier][]

Furthermore, in case someone decides to use the [Debian][] image as their
complete workflow environment, it also bundles:

-   [Git][]
-   [Vim][]

However, in general, I recommend using an [Alpine][] image as it has only the
most essential stuff.

## Usage

### Pulling

#### Alpine

```bash
$ docker pull viktorpopkov/dst-mod:alpine
```

#### Debian

```bash
$ docker pull viktorpopkov/dst-mod:debian
```

### Interactive Shell

```bash
$ cd <your mod directory>
$ docker run --rm --interactive --tty \
    --mount src="$(pwd)",target=/mod/,type=bind \
    --workdir=/mod \
    viktorpopkov/dst-mod:alpine
```

### Running Tool

Running [Luacheck][], as an example:

```bash
$ cd <your mod directory>
$ docker run --rm \
    --mount src="$(pwd)",target=/mod/,type=bind \
    --workdir=/mod \
    viktorpopkov/dst-mod:alpine
    luacheck .
```

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).

[alpine]: https://hub.docker.com/_/alpine
[busted]: https://olivinelabs.com/busted/
[debian]: https://hub.docker.com/_/debian
[docker]: https://www.docker.com/
[don't starve together]: https://www.klei.com/games/dont-starve-together
[git]: https://git-scm.com/
[gnu make]: https://www.gnu.org/software/make/
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
[vim]: https://www.vim.org/
