FROM ubuntu:18.04
MAINTAINER Chan-Ho Suh <csuh.web@gmail.com>

# Bitcoin Core dependencies and install instructions from
# https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update && apt-get install -y libdb4.8-dev libdb4.8++-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        make \
        python3 \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-chrono-dev \
        libboost-test-dev \
        libboost-thread-dev \
        libevent-dev \
        libssl-dev \
        libtool \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*


WORKDIR bitcoin
COPY . .

RUN rm -rf Makefile

# Install local code
RUN ./autogen.sh \
    && ./configure CFLAGS="-Os" CXXFLAGS="-Os" \
       # --disable-wallet \
       --without-gui \
       --without-miniupnpc \
       # --disable-tests \
       # --disable-bench \
    && make \
    # && strip src/bitcoind src/bitcoin-cli src/bitcoin-tx \
	&& make install

WORKDIR ../

 
# create data directory
ENV DATA_DIR /data
RUN mkdir "$DATA_DIR"
 
 
# install config
ENV CONFIG_FILE=/root/.bitcoin/bitcoin.conf
COPY bitcoin.conf "$CONFIG_FILE"
 
 
CMD bitcoind -printtoconsole -conf="$CONFIG_FILE" -datadir="$DATA_DIR"
