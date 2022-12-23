ARG DS_KTOOLS_VERSION="4.5.1"

FROM dstmodders/ktools:${DS_KTOOLS_VERSION}-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ENV DS_MODS="/opt/dont_starve/mods/"
ENV DST_MODS="${DS_MODS}"
ENV LCOV_VERSION="1.16"
ENV LUAROCKS_VERSION="3.8.0"
ENV LUA_VERSION="5.1.5"

WORKDIR /tmp/
# hadolint ignore=DL3003
RUN deluser --remove-home ktools \
  && addgroup -g 1000 dst-mod \
  && adduser -u 1000 -G dst-mod -s /bin/sh -D dst-mod \
  && apk add --no-cache \
    ca-certificates='20220614-r3' \
    curl='7.87.0-r0' \
    g++='12.2.1_git20220924-r4' \
    make='4.3-r1' \
    nodejs='18.12.1-r0' \
    openssl='3.0.7-r0' \
    readline-dev='8.2.0-r0' \
    rsync='3.2.7-r0' \
    yarn='1.22.19-r0' \
    zip='3.0-r10' \
  && apk add --no-cache --virtual .build-deps \
    bash='5.2.15-r0' \
    git='2.38.2-r0' \
    perl='5.36.0-r0' \
  # Lua
  && wget -q "https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz" \
  && tar zxf "./lua-${LUA_VERSION}.tar.gz" \
  && cd "/tmp/lua-${LUA_VERSION}/" \
  && make linux test \
  && make install \
  && cd /tmp/ \
  # LuaRocks
  && wget -q "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" \
  && tar zxf "/tmp/luarocks-${LUAROCKS_VERSION}.tar.gz" \
  && cd "/tmp/luarocks-${LUAROCKS_VERSION}/" \
  && ./configure \
  && make \
  && make install \
  && cd /tmp/ \
  # LCOV \
  && wget -q "https://github.com/linux-test-project/lcov/archive/refs/tags/v${LCOV_VERSION}.zip" \
  && unzip "./v${LCOV_VERSION}.zip" \
  && cd "./lcov-${LCOV_VERSION}/" \
  && make install \
  && cd /tmp/ \
  # clean
  && apk del .build-deps \
  && rm -Rf /tmp/*

# hadolint ignore=DL3059
RUN luarocks install busted '2.1.1-1' \
  && luarocks install cluacov '0.1.2-1' \
  && luarocks install ldoc '1.4.6-2' \
  && luarocks install luacheck '0.26.1-1' \
  && luarocks install luacov '0.15.0-1' \
  && luarocks install luacov-console '1.1.0-1' \
  && luarocks install luacov-reporter-lcov '0.2-0' \
  && rm -Rf /root/.cache/

# hadolint ignore=DL3059
RUN yarn global add \
  prettier@2.8.1 \
  @prettier/plugin-xml@2.2.0

WORKDIR ${DST_MODS}
