FROM debian:bullseye

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="4.4.0"
ENV DS_MODS="/mods"
ENV DS_TOOLS_AUTOCOMPILER="/tools/autocompiler"
ENV DS_TOOLS_PNG="/tools/png"
ENV DS_TOOLS_SCML="/tools/scml"
ENV DST_MODS="/mods"
ENV IMAGEMAGICK_VERSION="6.9.11-3"
ENV LUA_VERSION="5.1.5"
ENV LUAROCKS_VERSION="3.7.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion='1:2.11-2' \
    build-essential='12.9' \
    ca-certificates='20210119' \
    cmake='3.18.4-2' \
    curl='7.74.0-1.3+b1' \
    git='1:2.30.2-1' \
    libpng-dev='1.6.37-3' \
    libreadline-dev='8.1-1' \
    libzip-dev='1.7.3-1' \
    openssh-client='1:8.4p1-5' \
    pkg-config='0.29.2-1' \
    premake4='4.3+repack1-2+b1' \
    python3-pip='20.3.4-4' \
    rsync='3.2.3-4' \
    unzip='6.0-26' \
    vim='2:8.2.2434-3' \
    wget='1.21-1+b1' \
    zip='3.0-12' \
  # NodeJS and Yarn
  && wget -P /tmp/ https://deb.nodesource.com/setup_14.x \
  && bash /tmp/setup_14.x \
  && apt-get install -y --no-install-recommends nodejs='14.17.5-deb-1nodesource1' \
  && npm install -g yarn@1.22.11 \
  # Yarn packages
  && yarn global add \
    prettier@2.3.2 \
    @prettier/plugin-xml@1.0.2 \
  # Python packages
  && pip install pillow=='8.3.1' \
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
RUN luarocks install busted '2.0.0-1' \
  && luarocks install cluacov '0.1.2-1' \
  && luarocks install ldoc '1.4.6-2' \
  && luarocks install luacheck '0.24.0-2' \
  && luarocks install luacov '0.15.0-1' \
  && luarocks install luacov-console '1.1.0-1' \
  && luarocks install luacov-reporter-lcov '0.2-0'

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
RUN mkdir /temp/ && chown 1000:1000 /temp/ && make && mv /tmp/ds_mod_tools/build/linux/mod_tools/ /tools/

# Remove dependencies and temporary files
RUN apt-get remove -y \
    cmake \
    npm \
    pkg-config \
    premake4 \
  && rm -Rf /tmp/*

# Create user dst-mod
RUN addgroup --gid=1000 dst-mod \
  && useradd --create-home --uid=1000 --gid='dst-mod' --shell /bin/bash dst-mod

WORKDIR /mod/
