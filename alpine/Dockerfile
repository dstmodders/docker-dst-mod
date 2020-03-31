FROM alpine:latest

ENV DS_KTOOLS_KRANE="/usr/local/bin/krane"
ENV DS_KTOOLS_KTECH="/usr/local/bin/ktech"
ENV IMAGEMAGICK_VERSION="6.9.11-3"
ENV KTOOLS_VERSION="4.4.0"
ENV LUAROCKS_VERSION="3.3.1"
ENV LUA_VERSION="5.1.5"

# Install dependencies
RUN apk update \
    && apk add --no-cache \
        gcc \
        libc-dev \
        libpng-dev \
        libzip-dev \
        make \
        nodejs \
        readline-dev \
        yarn \
    && apk add --no-cache --virtual .build-deps \
        ca-certificates \
        cmake \
        curl \
        g++ \
        git \
        openssl \
        unzip \
        vim \
        wget

# Install Lua and LuaRocks
RUN cd /tmp/ \
    && wget "http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz" \
    && tar zxf "lua-${LUA_VERSION}.tar.gz" \
    && cd "lua-${LUA_VERSION}" \
    && make linux test \
    && make install \
    && cd /tmp/ \
    && rm -Rf lua-${LUA_VERSION}* \
    && wget "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz" \
    && tar zxpf "luarocks-${LUAROCKS_VERSION}.tar.gz" \
    && cd luarocks-${LUAROCKS_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd /tmp/ \
    && rm -Rf luarocks-${LUAROCKS_VERSION}*

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
    && cd ktools \
    && cmake \
        -DImageMagick_Magick++_LIBRARY="/usr/local/lib/libMagick++-6.Q16.so" \
        -DImageMagick_MagickCore_INCLUDE_DIR="/usr/local/include/ImageMagick-6" \
        -DImageMagick_MagickCore_LIBRARY="/usr/local/lib/libMagickCore-6.Q16.so" \
        -DImageMagick_MagickWand_INCLUDE_DIR="/usr/local/include/ImageMagick-6" \
        -DImageMagick_MagickWand_LIBRARY="/usr/local/lib/libMagickWand-6.Q16.so" \
     . \
    && ./configure \
    && make \
    && make install \
    && cd /tmp/ \
    && rm -Rf ktools* \
    && rm -Rf ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz ImageMagick-${IMAGEMAGICK_VERSION}*

# Remove dependencies
RUN apk del .build-deps
