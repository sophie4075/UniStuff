FROM i386/ubuntu:12.04

RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    wget curl git cmake make g++ bzip2 \
    libtool autoconf automake pkg-config \
    qt4-qmake libqt4-dev libphonon-dev \
    libssl-dev libjpeg62 libicu48 xvfb

WORKDIR /opt
RUN wget https://download.qt.io/archive/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz && \
    tar -xzf qt-everywhere-opensource-src-4.8.7.tar.gz && \
    cd qt-everywhere-opensource-src-4.8.7 && \
    ./configure -opensource -confirm-license \
        -release -nomake examples -nomake demos -no-qt3support -no-scripttools \
        -no-opengl -no-webkit -no-phonon -no-sql-sqlite -gtkstyle \
        -prefix /usr/local/Qt-4.8.7-release && \
    make -j$(nproc) && make install

ENV PATH="/usr/local/Qt-4.8.7-release/bin:$PATH"
ENV CMAKE_PREFIX_PATH="/usr/local/Qt-4.8.7-release"

WORKDIR /opt
RUN wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/qca2/2.0.3-5/qca2_2.0.3.orig.tar.bz2 && \
    tar -xjf qca2_2.0.3.orig.tar.bz2

ADD https://raw.githubusercontent.com/DarkReZuS/silenteye/0.4/vagrant/vagrant_data/fix_build_gcc4.7.diff /opt/fix_build_gcc4.7.diff
WORKDIR /opt/qca-2.0.3
RUN patch src/botantools/botan/botan/secmem.h < /opt/fix_build_gcc4.7.diff && \
    ./configure --prefix=/usr --qtdir=/usr/local/Qt-4.8.7-release && \
    make -j$(nproc) && make install

WORKDIR /opt
#neu
RUN wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/qca2-plugin-ossl/2.0.0~beta3-2/qca2-plugin-ossl_2.0.0~beta3.orig.tar.bz2 && \
    tar -xjf qca2-plugin-ossl_2.0.0~beta3.orig.tar.bz2

ADD https://raw.githubusercontent.com/DarkReZuS/silenteye/0.4/vagrant/vagrant_data/detect_ssl2_available.diff /opt/detect_ssl2_available.diff
ADD https://raw.githubusercontent.com/DarkReZuS/silenteye/0.4/vagrant/vagrant_data/detect_md2_available.diff /opt/detect_md2_available.diff

WORKDIR /opt/qca-ossl-2.0.0-beta3
RUN patch qca-ossl.cpp < /opt/detect_ssl2_available.diff && \
    patch qca-ossl.cpp < /opt/detect_md2_available.diff && \
    ./configure --qtdir=/usr/local/Qt-4.8.7-release && \
    make -j$(nproc) && make install

WORKDIR /opt
RUN git clone --branch 0.4 https://github.com/achorein/silenteye.git

WORKDIR /opt/silenteye
RUN ENABLE_MODULE=1 cmake . && make -j$(nproc) && make install

#ENV SILENTEYE_PLUGIN_PATH=/opt/silenteye/modules

CMD ["./silenteye"]
