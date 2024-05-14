ARG DS_KLEI_TOOLS_VERSION="1.0.0"

FROM dstmodders/klei-tools:${DS_KLEI_TOOLS_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DS_MODS="/opt/dont_starve/mods/"
ENV DST_MODS="${DS_MODS}"
ENV LCOV_VERSION="2.1"
ENV LUAROCKS_VERSION="3.11.0"
ENV LUA_VERSION="5.1.5"
ENV STYLUA_VERSION="0.17.1"

USER root
WORKDIR /tmp/
# hadolint ignore=DL3003
RUN sed -i 's/klei-tools/dst-mod/g' /etc/passwd /etc/group \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion='1:2.11-6' \
    build-essential='12.9' \
    ca-certificates='20230311' \
    curl='7.88.1-10+deb12u5' \
    git='1:2.39.2-1.1' \
    libreadline-dev='8.2-1.3' \
    openssh-client='1:9.2p1-2+deb12u2' \
    pkg-config='1.8.1-1' \
    premake4='4.3+repack1-2+b1' \
    rsync='3.2.7-1' \
    unzip='6.0-28' \
    vim='2:9.0.1378-2' \
    wget='1.21.3-1+b2' \
    zip='3.0-13' \
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
  # StyLua
  && wget -q "https://github.com/JohnnyMorganz/StyLua/releases/download/v${STYLUA_VERSION}/stylua-linux.zip" \
  && unzip "./stylua-linux.zip" \
  && chmod +x ./stylua \
  && mv ./stylua /usr/bin/stylua \
  && cd /tmp/ \
  # clean \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf \
    /root/.cache/ \
    /root/.wget-hsts \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log

# hadolint ignore=DL3059
RUN luarocks install busted '2.2.0-1' \
  && luarocks install cluacov '0.1.2-1' \
  && luarocks install ldoc '1.5.0-1' \
  && luarocks install luacheck '1.1.2-1' \
  && luarocks install luacov '0.15.0-1' \
  && luarocks install luacov-console '1.1.0-1' \
  && luarocks install luacov-reporter-lcov '0.2-0' \
  && rm -Rf \
    /root/.cache/ \
    /root/.wget-hsts

# hadolint ignore=DL3059
RUN wget -q https://deb.nodesource.com/setup_20.x \
  && chmod +x setup_20.x \
  && ./setup_20.x \
  && apt-get install -y --no-install-recommends \
    nodejs='20.13.1-1nodesource1' \
  && npm install --location=global npm@10.5.2 \
  # Yarn + packages
  && npm install --location=global yarn@1.22.22 \
  && yarn global add \
    prettier@3.2.5 \
    @prettier/plugin-xml@3.4.1 \
  # clean
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -Rf \
    /root/.wget-hsts \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/log/alternatives.log \
    /var/log/apt/ \
    /var/log/dpkg.log

USER dst-mod
WORKDIR ${DST_MODS}
