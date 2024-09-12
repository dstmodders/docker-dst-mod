ARG IMAGEMAGICK_VERSION="7.1.1-38"
ARG KTOOLS_VERSION="4.5.1"

FROM dstmodders/ktools:${KTOOLS_VERSION}-imagemagick-${IMAGEMAGICK_VERSION}-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ENV DS_MODS="/opt/dont_starve/mods/"
ENV DST_MODS="${DS_MODS}"
ENV LCOV_VERSION="2.1"
ENV LUAROCKS_VERSION="3.8.0"
ENV LUA_VERSION="5.1.5"

USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN sed -i 's/ktools/dst-mod/g' /etc/passwd /etc/group \
  && apk add --no-cache \
    ca-certificates='20240226-r0' \
    curl='8.9.1-r0' \
    g++='13.2.1_git20231014-r0' \
    make='4.4.1-r2' \
    nodejs='20.15.1-r0' \
    openssl='3.1.7-r0' \
    readline-dev='8.2.1-r2' \
    rsync='3.2.7-r4' \
    yarn='1.22.19-r0' \
    zip='3.0-r12' \
  && apk add --no-cache --virtual .build-deps \
    bash='5.2.21-r0' \
    git='2.43.4-r0' \
    perl='5.38.2-r0' \
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
  # LCOV
  && wget -q "https://github.com/linux-test-project/lcov/archive/refs/tags/v${LCOV_VERSION}.zip" \
  && unzip "./v${LCOV_VERSION}.zip" \
  && cd "./lcov-${LCOV_VERSION}/" \
  && make install \
  && cd /tmp/ \
  # clean
  && apk del .build-deps \
  && rm -Rf /tmp/*

# hadolint ignore=DL3059
RUN luarocks install busted '2.2.0-1' \
  && luarocks install cluacov '0.1.4-1' \
  && luarocks install ldoc '1.5.0-1' \
  && luarocks install luacheck '1.2.0-1' \
  && luarocks install luacov '0.15.0-1' \
  && luarocks install luacov-console '1.1.0-1' \
  && luarocks install luacov-reporter-lcov '0.2-0' \
  && rm -Rf /root/.cache/

# hadolint ignore=DL3059
RUN yarn global add \
  prettier@3.3.3 \
  @prettier/plugin-xml@3.4.1

USER dst-mod
WORKDIR ${DST_MODS}
