FROM ubuntu
ADD https://sunsite.icm.edu.pl/pub/gnu/binutils/binutils-2.33.1.tar.gz /root/src
ADD https://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.gz /root/src
ENV TARGET=i686-elf \
    PREFIX=/opt/local \
    PATH="/opt/local/bin:${PATH}"
RUN apt-get update && apt-get -y upgrade; \
    apt-get -y install make nasm gcc g++ xorriso curl; \
    apt-get -y install libgmp-dev libmpfr-dev libmpc-dev; \
    apt-get -y install grub-common; \
    cd $HOME/src; \
    mkdir build-binutils && cd build-binutils; \
    ../binutils-2.31.1/configure --target=$TARGET --prefix="$PREFIX" --disable-multilib --disable-nls --disable-werror; \
    make && make install; \
    cd $HOME/src && mkdir build-gcc && cd build-gcc; \
    ../gcc-8.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-multilib --disable-nls --enable-languages=c,c++ --without-headers; \
    make all-gcc; \
    make all-target-libgcc; \
    make install-gcc; \
    make install-target-libgcc; \
    apt-get -y purge libgmp-dev libmpfr-dev libmpc-dev; \
    apt-get -y autoremove; \
    apt-get -y autoclean; \
    apt-get -y clean; \
    rm -rf /root/src
