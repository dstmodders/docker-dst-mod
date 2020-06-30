FROM debian:buster

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV IMAGEMAGICK_VERSION="6.9.11-3"
ENV KTOOLS_VERSION="4.4.0"
ENV LUAROCKS_VERSION="3.3.1"
ENV LUA_VERSION="5.1.5"

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    libpng-dev \
    libreadline-dev \
    libzip-dev \
    nodejs \
    npm \
    openssh-client \
    pkg-config \
    rsync \
    unzip \
    vim \
    wget \
  && apt-get clean \
  && rm -Rf /var/lib/apt/lists/* \
  && npm install -g yarn

# Install Lua and LuaRocks
RUN cd /tmp/ \
  && wget "http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz" \
  && tar zxf "lua-${LUA_VERSION}.tar.gz" \
  && cd "lua-${LUA_VERSION}" \
  && make linux test \
  && make install \
  && cd /tmp/ \
  && rm -Rf "lua-${LUA_VERSION}*" \
  && wget "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" \
  && tar zxpf "luarocks-${LUAROCKS_VERSION}.tar.gz" \
  && cd "luarocks-${LUAROCKS_VERSION}" \
  && ./configure \
  && make \
  && make install \
  && cd /tmp/ \
  && rm -Rf "luarocks-${LUAROCKS_VERSION}*"

# Install tools
RUN luarocks install busted \
  && luarocks install ldoc \
  && luarocks install luacheck \
  && luarocks install luacov \
  && luarocks install luacov-console \
  && yarn global add prettier

# Install ImageMagick and ktools
RUN cd /tmp/ \
  && wget "https://imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && tar xf "ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" \
  && cd "ImageMagick-${IMAGEMAGICK_VERSION}" \
  && ./configure \
  && make \
  && make install \
  && ldconfig /usr/local/lib \
  && cd /tmp/ \
  && git clone https://github.com/victorpopkov/ktools.git \
  && cd ktools/ \
  && cmake \
    -DImageMagick_Magick++_LIBRARY="$(pkg-config --variable=libdir Magick++)/lib$(pkg-config --variable=libname Magick++).so" \
    -DImageMagick_MagickCore_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickCore | tail -c+3)" \
    -DImageMagick_MagickCore_LIBRARY="$(pkg-config --variable=libdir MagickCore)/lib$(pkg-config --variable=libname MagickCore).so" \
    -DImageMagick_MagickWand_INCLUDE_DIR="$(pkg-config --cflags-only-I MagickWand | tail -c+3)" \
    -DImageMagick_MagickWand_LIBRARY="$(pkg-config --variable=libdir MagickWand)/lib$(pkg-config --variable=libname MagickWand).so" \
   . \
  && ./configure \
  && make \
  && make install \
  && cd /tmp/ \
  && rm -Rf ktools* \
  && rm -Rf "ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz" "ImageMagick-${IMAGEMAGICK_VERSION}*"

# Remove dependencies
RUN apt-get remove -y \
  cmake \
  npm \
  pkg-config
