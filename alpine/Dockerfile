ARG DS_KTOOLS_VERSION="4.5.0"

FROM viktorpopkov/ktools:${DS_KTOOLS_VERSION}-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ENV DS_MODS="/opt/dont_starve/mods/"
ENV DST_MODS="${DS_MODS}"
ENV LCOV_VERSION="1.15"
ENV LUAROCKS_VERSION="3.7.0"
ENV LUA_VERSION="5.1.5"

WORKDIR /tmp/
RUN deluser --remove-home ktools \
  && addgroup -g 1000 dst-mod \
  && adduser -u 1000 -G dst-mod -s /bin/sh -D dst-mod \
  && apk add --no-cache \
    ca-certificates='20191127-r5' \
    curl='7.78.0-r0' \
    g++='10.3.1_git20210424-r2' \
    make='4.3-r0' \
    nodejs='14.17.6-r0' \
    openssl='1.1.1l-r0' \
    readline-dev='8.1.0-r0' \
    rsync='3.2.3-r4' \
    yarn='1.22.10-r0' \
    zip='3.0-r9' \
  && apk add --no-cache --virtual .build-deps \
    bash='5.1.4-r0' \
    git='2.32.0-r0' \
    perl='5.32.1-r0' \
  # Lua
  && wget "https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz" \
  && tar zxf "./lua-${LUA_VERSION}.tar.gz" \
  && cd "/tmp/lua-${LUA_VERSION}/" \
  && make linux test \
  && make install \
  && cd /tmp/ \
  # LuaRocks
  && wget "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" \
  && tar zxf "/tmp/luarocks-${LUAROCKS_VERSION}.tar.gz" \
  && cd "/tmp/luarocks-${LUAROCKS_VERSION}/" \
  && ./configure \
  && make \
  && make install \
  && cd /tmp/ \
  # LCOV \
  && wget "https://github.com/linux-test-project/lcov/archive/refs/tags/v${LCOV_VERSION}.zip" \
  && unzip "./v${LCOV_VERSION}.zip" \
  && cd "./lcov-${LCOV_VERSION}/" \
  && make install \
  && cd /tmp/ \
  # clean
  && apk del .build-deps \
  && rm -Rf /tmp/*

RUN luarocks install busted '2.0.0-1' \
  && luarocks install cluacov '0.1.2-1' \
  && luarocks install ldoc '1.4.6-2' \
  && luarocks install luacheck '0.24.0-2' \
  && luarocks install luacov '0.15.0-1' \
  && luarocks install luacov-console '1.1.0-1' \
  && luarocks install luacov-reporter-lcov '0.2-0' \
  && rm -Rf /root/.cache/

RUN yarn global add \
  prettier@2.3.2 \
  @prettier/plugin-xml@1.0.2

WORKDIR ${DST_MODS}
