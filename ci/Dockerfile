FROM fedora:32 AS fedora-base

FROM fedora-base AS fedora-download
RUN dnf --nodocs install -y --setopt=install_weak_deps=False \
    git bzip2 lzo p7zip wget xz \
    && rm -rf /var/cache/dnf

FROM fedora-base AS fedora-build
RUN dnf --nodocs install -y --setopt=install_weak_deps=False \
    clang \
    clang-analyzer \
    cmake \
    cppcheck \
    gcc \
    gcc-c++ \
    git \
    gnutls-devel \
    harfbuzz \
    libargon2 \
    libicu \
    libpng \
    libsodium-devel \
    llvm \
    lmdb-devel \
    mesa-libGL \
    mesa-libOSMesa \
    msgpack-devel \
    ninja-build \
    openssl-devel \
    protobuf-compiler \
    protobuf-lite-devel \
    sqlite-devel \
    which \
    zeromq-devel \
    && rm -rf /var/cache/dnf

FROM fedora-download AS gtest-download
ARG GTEST_VERSION="release-1.11.0"
RUN mkdir -p /tmp/gtest/
RUN wget -O /tmp/gtest/gtest.tar.gz https://github.com/google/googletest/archive/refs/tags/${GTEST_VERSION}.tar.gz
RUN cd /tmp/gtest && \
    tar -xf "gtest.tar.gz" && \
    rm -f "gtest.tar.gz" && \
    mkdir -p /usr/src && \
    mv googletest-release-* /usr/src/gtest

FROM fedora-download AS iwyu-download
ARG IWYU_BRANCH="clang_10"
RUN mkdir -p /usr/src \
    && git clone --recursive "https://github.com/include-what-you-use/include-what-you-use" /usr/src/iwyu \
    && cd /usr/src/iwyu \
    && git checkout "${IWYU_BRANCH}"

FROM fedora-download AS boost-download
ARG BOOST_MAJOR="1"
ARG BOOST_MINOR="75"
ARG BOOST_PATCH="0"
RUN mkdir -p /usr/src \
    && wget -O /usr/src/boost.tar.bz2 "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_MAJOR}.${BOOST_MINOR}.${BOOST_PATCH}/source/boost_${BOOST_MAJOR}_${BOOST_MINOR}_${BOOST_PATCH}.tar.bz2" \
    && tar -xf /usr/src/boost.tar.bz2 -C /usr/src \
    && rm /usr/src/boost.tar.bz2 \
    && mv "/usr/src/boost_${BOOST_MAJOR}_${BOOST_MINOR}_${BOOST_PATCH}" /usr/src/boost

FROM fedora-download AS cmake-download
ARG CMAKE_VERSION="3.23.2"
RUN mkdir -p /usr/src \
    && cd /usr/src \
    && wget -O /usr/src/cmake.tar.gz "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz" \
    && tar -xf cmake.tar.gz \
    && rm cmake.tar.gz \
    && mv "cmake-${CMAKE_VERSION}" cmake

FROM fedora-download AS qt-download
ARG QT_BRANCH=5.15
ARG QT_VERSION=5.15.5
RUN mkdir -p /usr/src && cd /usr/src \
    && wget "https://download.qt.io/official_releases/qt/${QT_BRANCH}/${QT_VERSION}/single/qt-everywhere-opensource-src-${QT_VERSION}.tar.xz" \
    && tar -xf "qt-everywhere-opensource-src-${QT_VERSION}.tar.xz" \
    && rm "qt-everywhere-opensource-src-${QT_VERSION}.tar.xz" \
    && mv qt-everywhere-src-${QT_VERSION} qt

FROM fedora-download AS opendht-download
ARG OPENDHT_TAG="2.4.5"
RUN mkdir -p /usr/src \
    && git clone --recursive "https://github.com/savoirfairelinux/opendht" /usr/src/opendht \
    && cd /usr/src/opendht \
    && git checkout "${OPENDHT_TAG}"

FROM fedora-build AS fedora-gtest
COPY --from=gtest-download /usr/src/gtest /usr/src/gtest
RUN mkdir -p /tmp/gtest
RUN cd /tmp/gtest && \
    cmake -DBUILD_SHARED_LIBS=ON /usr/src/gtest && \
    make install

FROM fedora-build AS fedora-iwyu
RUN dnf --nodocs install -y --setopt=install_weak_deps=False \
    clang-devel llvm-devel \
    && rm -rf /var/cache/dnf
COPY --from=iwyu-download /usr/src/iwyu /usr/src/iwyu
RUN mkdir -p /tmp/iwyu && cd /tmp/iwyu \
    && cmake -GNinja /usr/src/iwyu \
    && cmake --build . \
    && cmake --install . \
    && rm -rf /tmp/iwyu

FROM fedora-build AS fedora-boost
COPY --from=boost-download /usr/src/boost /usr/src/boost
RUN cd /usr/src/boost \
    && ./bootstrap.sh --prefix=/usr/local --with-libraries=all \
    && ./b2 \
    && ./b2 install

FROM fedora-build AS fedora-cmake
COPY --from=cmake-download /usr/src/cmake /usr/src/cmake
RUN mkdir -p /tmp/build \
    && cd /tmp/build \
    && cmake -GNinja /usr/src/cmake \
    && cmake --build . \
    && cmake --install .

FROM fedora-build as fedora-qt
RUN dnf --nodocs install -y --setopt=install_weak_deps=False \
    SDL2-devel \
    assimp-devel \
    bison \
    bluez-libs-devel \
    clang-devel \
    cups-devel \
    dbus-devel \
    egl-wayland-devel \
    expat-devel \
    flex \
    fontconfig-devel \
    freetype-devel \
    gperf \
    harfbuzz-devel \
    jsoncpp-devel \
    lcms2-devel \
    libX11-devel \
    libXext-devel \
    libXfixes-devel \
    libXi-devel \
    libXinerama-devel \
    libXrandr-devel \
    libXrender-devel \
    libevent-devel \
    libicu-devel \
    libjpeg-devel \
    libpng-devel \
    libproxy-devel \
    libstdc++-devel \
    libstdc++-static \
    libtiff-devel \
    libvpx-devel \
    libwebp-devel \
    libxcb-devel \
    libxkbcommon-devel \
    libxkbcommon-x11-devel \
    libxml2-devel \
    libxslt-devel \
    mesa-libOSMesa-devel \
    mysql-devel \
    nss-devel \
    openssl-devel \
    opus-devel \
    pcre2-devel \
    protobuf-devel \
    python2 \
    snappy-devel \
    sqlite-devel \
    vulkan-devel \
    wayland-devel \
    zlib-devel \
    && rm -rf /var/cache/dnf
COPY --from=qt-download /usr/src/qt /usr/src/qt
ARG JOBS=12
#required qtbase qtdeclarative qtquickcontrols2 qtsvg
RUN mkdir -p /tmp/build && cd /tmp/build && /usr/src/qt/configure \
    --prefix=/usr/local \
    -opensource \
    -confirm-license \
    -nomake tests \
    -nomake examples \
    -no-warnings-are-errors \
    -c++std c++17 \
    -system-zlib \
    -system-sqlite \
    -skip qt3d \
    -skip qtactiveqt \
    -skip qtandroidextras \
    -skip qtcharts \
    -skip qtconnectivity \
    -skip qtdatavis3d \
    -skip qtdoc \
    -skip qtgamepad \
    -skip qtgraphicaleffects \
    -skip qtimageformats \
    -skip qtlocation \
    -skip qtlottie \
    -skip qtmacextras \
    -skip qtmultimedia \
    -skip qtnetworkauth \
    -skip qtpurchasing \
    -skip qtquick3d \
    -skip qtquickcontrols \
    -skip qtquicktimeline \
    -skip qtremoteobjects \
    -skip qtscript \
    -skip qtscxml \
    -skip qtsensors \
    -skip qtserialbus \
    -skip qtserialport \
    -skip qtspeech \
    -skip qttools \
    -skip qttranslations \
    -skip qtvirtualkeyboard \
    -skip qtwayland \
    -skip qtwebchannel \
    -skip qtwebengine \
    && make -j$JOBS \
    && make install \
    && rm -rf /tmp/build

FROM fedora-build AS fedora-opendht
RUN dnf --nodocs install -y --setopt=install_weak_deps=False \
    libargon2-devel \
    && rm -rf /var/cache/dnf
COPY --from=opendht-download /usr/src/opendht /usr/src/opendht
RUN mkdir -p /tmp/opendht && cd /tmp/opendht \
    && cmake \
        -GNinja \
        -DOPENDHT_STATIC=OFF \
        -DOPENDHT_LOG=OFF \
        -DOPENDHT_TOOLS=OFF \
        -DOPENDHT_PROXY_OPENSSL=OFF \
        -DOPENDHT_PEER_DISCOVERY=OFF \
        -DOPENDHT_TESTS_NETWORK=OFF \
        -DOPENDHT_DOCUMENTATION=OFF \
        /usr/src/opendht \
    && cmake --build . \
    && cmake --install . \
    && rm -rf /tmp/opendht

FROM fedora-build AS opentxs-fedora-ci
COPY --from=fedora-gtest /usr/local /usr
COPY --from=fedora-iwyu /usr/local /usr
COPY --from=fedora-boost /usr/local /usr/local
COPY --from=fedora-cmake /usr/local /usr/local
COPY --from=fedora-qt /usr/local /usr/local
COPY --from=fedora-opendht /usr/local /usr/local
RUN ldconfig
COPY ./build-opentxs.sh /usr/bin
COPY ./build-opentxs-clang.sh /usr/bin
COPY ./build-opentxs-gcc.sh /usr/bin
COPY ./test-opentxs.sh /usr/bin
COPY ./opentxs-config.sh /var/lib
RUN chmod a+x /usr/bin/build-opentxs.sh
RUN chmod a+x /usr/bin/build-opentxs-clang.sh
RUN chmod a+x /usr/bin/build-opentxs-gcc.sh
RUN chmod a+x /usr/bin/test-opentxs.sh
