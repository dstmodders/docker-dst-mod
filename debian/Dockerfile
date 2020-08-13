FROM debian:buster

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="4.4.0"
ENV DS_MODS="/mods/"
ENV DS_TOOLS_AUTOCOMPILER="/ds-mod-tools/autocompiler"
ENV DS_TOOLS_PNG="/ds-mod-tools/png"
ENV DS_TOOLS_SCML="/ds-mod-tools/scml"
ENV DST_MODS="/mods/"
ENV IMAGEMAGICK_VERSION="6.9.11-3"
ENV LUA_VERSION="5.1.5"
ENV LUAROCKS_VERSION="3.3.1"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion='1:2.8-6' \
    build-essential='12.6' \
    ca-certificates='20200601~deb10u1' \
    cmake='3.13.4-1' \
    curl='7.64.0-4+deb10u1' \
    git='1:2.20.1-2+deb10u3' \
    libpng-dev='1.6.36-6' \
    libreadline-dev='7.0-5' \
    libzip-dev='1.5.1-4' \
    openssh-client='1:7.9p1-10+deb10u2' \
    pkg-config='0.29-6' \
    premake4='4.3+repack1-2+b1' \
    python-pip='18.1-5' \
    rsync='3.1.3-6' \
    unzip='6.0-23+deb10u1' \
    vim='2:8.1.0875-5' \
    wget='1.20.1-1.1' \
  # NodeJS and Yarn
  && wget -P /tmp/ https://deb.nodesource.com/setup_12.x \
  && bash /tmp/setup_12.x \
  && apt-get install -y --no-install-recommends nodejs='12.18.3-1nodesource1' \
  && npm install -g yarn@1.22.4 \
  # Yarn packages
  && yarn global add \
    prettier@2.0.5 \
    @prettier/plugin-xml@0.8.0 \
  # Python packages
  && pip install pillow=='6.2.2' \
  # Clean
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/*

# Download and extract Lua, LuaRocks, ImageMagick and ktools
RUN wget -P /tmp/ "http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz" \
  && tar zxf "/tmp/lua-${LUA_VERSION}.tar.gz" -C /tmp/ \
  # LuaRocks
  && wget -P /tmp/ "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" \
  && tar zxf "/tmp/luarocks-${LUAROCKS_VERSION}.tar.gz" -C /tmp/ \
  # LCOV
  && git clone https://github.com/linux-test-project/lcov.git /tmp/lcov/ \
  # ImageMagick
  && wget -P /tmp/ "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar xf "/tmp/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" -C /tmp/ \
  # ktools
  && git clone https://github.com/victorpopkov/ktools.git /tmp/ktools/ \
  # ds_mod_tools
  && git clone https://github.com/kleientertainment/ds_mod_tools /tmp/ds_mod_tools/

# Build and install Lua
RUN make -C "/tmp/lua-${LUA_VERSION}/" linux test \
  && make -C "/tmp/lua-${LUA_VERSION}/" install

# Build and install LuaRocks
WORKDIR /tmp/luarocks-${LUAROCKS_VERSION}/
RUN ./configure \
  && make \
  && make install

# Install LuaRocks rocks
WORKDIR /root/
RUN luarocks install busted \
  && luarocks install cluacov \
  && luarocks install ldoc \
  && luarocks install luacheck \
  && luarocks install luacov \
  && luarocks install luacov-console \
  && luarocks install luacov-reporter-lcov

# Install LCOV
WORKDIR /tmp/lcov/
RUN make install

# Build and install ImageMagick
WORKDIR /tmp/ImageMagick-${IMAGEMAGICK_VERSION}/
RUN ./configure \
  && make \
  && make install \
  && ldconfig /usr/local/lib/

# Install ktools
WORKDIR /tmp/ktools/
RUN cmake \
    -DImageMagick_Magick++_LIBRARY="$(pkg-config --variable=libdir Magick++)/lib$(pkg-config --variable=libname Magick++).so" \
    -DImageMagick_MagickCore_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickCore | tail -c+3)" \
    -DImageMagick_MagickCore_LIBRARY="$(pkg-config --variable=libdir MagickCore)/lib$(pkg-config --variable=libname MagickCore).so" \
    -DImageMagick_MagickWand_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickWand | tail -c+3)" \
    -DImageMagick_MagickWand_LIBRARY="$(pkg-config --variable=libdir MagickWand)/lib$(pkg-config --variable=libname MagickWand).so" \
    . \
  && ./configure \
  && make \
  && make install

# Install ds_mod_tools
WORKDIR /tmp/ds_mod_tools/src/
RUN ./premake.sh
WORKDIR /tmp/ds_mod_tools/build/proj/
RUN make && mv /tmp/ds_mod_tools/build/linux/mod_tools/ /ds-mod-tools/

# Remove dependencies and temporary files
RUN apt-get remove -y \
    cmake \
    npm \
    pkg-config \
    premake4 \
  && rm -Rf /tmp/*

WORKDIR /mod/
