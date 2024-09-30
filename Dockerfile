FROM ubuntu:noble
WORKDIR /root/src
ADD https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.gz /root/src/
ADD https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz /root/src/
ENV TARGET=i686-elf \
    PREFIX=/root/opt/local \
    PATH="/root/opt/local/bin:${PATH}"
RUN apt-get update && apt-get -y upgrade; \
    apt-get -y install make nasm gcc g++ xorriso curl; \
    apt-get -y install libgmp-dev libmpfr-dev libmpc-dev; \
    apt-get -y install grub-pc grub-common file texinfo mtools; \
    tar -xzvf binutils-2.43.tar.gz; \
    tar -xzvf gcc-14.2.0.tar.gz; \
    mkdir build-binutils && cd build-binutils; \
    ../binutils-2.43/configure --target=$TARGET --prefix="$PREFIX" --disable-multilib --disable-nls --disable-werror; \
    make -j$(nproc) && make install; \
    cd $HOME/src && mkdir build-gcc && cd build-gcc; \
    ../gcc-14.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-multilib --disable-nls --enable-languages=c,c++ --without-headers; \
    make -j$(nproc) all-gcc; \
    make all-target-libgcc; \
    make install-gcc; \
    make install-target-libgcc; \
    apt-get -y purge libgmp-dev libmpfr-dev libmpc-dev; \
    apt-get -y autoremove; \
    apt-get -y autoclean; \
    apt-get -y clean; \
    rm -rf /root/src; \
    echo 'export PATH=/root/opt/local:$PATH' >> ~/.bashrc 
