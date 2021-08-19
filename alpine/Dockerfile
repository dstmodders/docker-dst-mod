FROM alpine:3.14.1

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV DS_KTOOLS_VERSION="4.4.0"
ENV DS_MODS="/mods"
ENV DST_MODS="/mods"
ENV IMAGEMAGICK_VERSION="6.9.11-3"
ENV LUA_VERSION="5.1.5"
ENV LUAROCKS_VERSION="3.3.1"

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Install dependencies and Yarn packages
RUN apk update \
  && apk add --no-cache \
    curl='7.78.0-r0' \
    gcc='10.3.1_git20210424-r2' \
    libc-dev='0.7.2-r3' \
    libpng-dev='1.6.37-r1' \
    libzip-dev='1.7.3-r2' \
    make='4.3-r0' \
    nodejs='14.17.4-r0' \
    openssl='1.1.1k-r0' \
    readline-dev='8.1.0-r0' \
    rsync='3.2.3-r4' \
    yarn='1.22.10-r0' \
    zip='3.0-r9' \
  && apk add --no-cache --virtual .build-deps \
    bash='5.1.4-r0' \
    ca-certificates='20191127-r5' \
    cmake='3.20.3-r0' \
    g++='10.3.1_git20210424-r2' \
    git='2.32.0-r0' \
    perl='5.32.1-r0' \
  && yarn global add \
    prettier@2.3.2 \
    @prettier/plugin-xml@1.0.2

# Download and extract Lua, LuaRocks, LCOV, ImageMagick and ktools
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
  && git clone https://github.com/victorpopkov/ktools.git /tmp/ktools/

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

# Remove dependencies and temporary files
RUN apk del .build-deps \
  && rm -Rf /tmp/*

# Create user dst-mod
RUN addgroup --gid=1000 dst-mod \
  && adduser --disabled-password --ingroup='dst-mod' --uid=1000 dst-mod

WORKDIR /mod/
