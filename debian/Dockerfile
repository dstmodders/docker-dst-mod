ARG DS_KLEI_TOOLS_VERSION="1.0.0"

FROM dstmodders/klei-tools:${DS_KLEI_TOOLS_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DS_MODS="/opt/dont_starve/mods/"
ENV DST_MODS="${DS_MODS}"
ENV LCOV_VERSION="1.15"
ENV LUAROCKS_VERSION="3.9.0"
ENV LUA_VERSION="5.1.5"
ENV STYLUA_VERSION="0.13.1"

WORKDIR /tmp/
# hadolint ignore=DL3003
RUN userdel -r klei-tools \
  && groupadd --gid 1000 dst-mod \
  && useradd \
    --uid 1000 \
    --gid dst-mod \
    --shell /bin/bash \
    --create-home \
    dst-mod \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion='1:2.11-2' \
    build-essential='12.9' \
    ca-certificates='20210119' \
    curl='7.74.0-1.3+deb11u1' \
    git='1:2.30.2-1' \
    libreadline-dev='8.1-1' \
    openssh-client='1:8.4p1-5' \
    pkg-config='0.29.2-1' \
    premake4='4.3+repack1-2+b1' \
    rsync='3.2.3-4+deb11u1' \
    unzip='6.0-26' \
    vim='2:8.2.2434-3+deb11u1' \
    wget='1.21-1+deb11u1' \
    zip='3.0-12' \
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
  # StyLua
  && wget -q "https://github.com/JohnnyMorganz/StyLua/releases/download/v${STYLUA_VERSION}/stylua-linux.zip" \
  && unzip "./stylua-linux.zip" \
  && chmod +x ./stylua \
  && mv ./stylua /usr/bin/stylua \
  && cd /tmp/ \
  # clean \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf /var/lib/apt/lists/* \
  && rm -Rf \
    /root/.cache/ \
    /root/.wget-hsts \
    /tmp/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log

# hadolint ignore=DL3059
RUN luarocks install busted '2.0.0-1' \
  && luarocks install cluacov '0.1.2-1' \
  && luarocks install ldoc '1.4.6-2' \
  && luarocks install luacheck '0.26.1-1' \
  && luarocks install luacov '0.15.0-1' \
  && luarocks install luacov-console '1.1.0-1' \
  && luarocks install luacov-reporter-lcov '0.2-0' \
  && rm -Rf \
    /root/.cache/ \
    /root/.wget-hsts

# hadolint ignore=DL3059
RUN wget -q https://deb.nodesource.com/setup_16.x \
  && chmod +x setup_16.x \
  && ./setup_16.x \
  && apt-get install -y --no-install-recommends \
    nodejs='16.14.2-deb-1nodesource1' \
  && npm install -g npm@8.7.0 \
  # Yarn + packages
  && npm install -g yarn@1.22.18 \
  && yarn global add \
    prettier@2.6.2 \
    @prettier/plugin-xml@2.1.0 \
  # clean
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf /var/lib/apt/lists/* \
  && rm -Rf \
    /root/.wget-hsts \
    /tmp/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log

WORKDIR ${DST_MODS}
