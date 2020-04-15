FROM ubuntu:18.04
MAINTAINER Chan-Ho Suh <csuh.web@gmail.com>

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND noninteractive

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
        curl \
        git \
        make \
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


# dependencies for python install from
# https://github.com/pyenv/pyenv/wiki
RUN apt-get update && apt-get install -y --no-install-recommends \
		libssl-dev \
		libbz2-dev \
  		libreadline-dev \
  		libsqlite3-dev \
  		llvm \
  		libncurses5-dev \
  		libffi-dev \
  		liblzma-dev \
		libxml2-dev \
		libxmlsec1-dev \
  		tk-dev \
  		wget \
  		xz-utils \
		zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
    
    
WORKDIR bitcoin
COPY ./.python-version .


# ensure we install the oldest supported python version
ENV PYENV_ROOT ${HOME}/.pyenv
ENV PATH ${PYENV_ROOT}/bin:${PATH}

RUN git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
RUN pyenv install $(cat .python-version)

RUN echo -e 'eval "$(pyenv init -)"' >> ${HOME}/.bashrc

RUN eval "$(pyenv init -)"; pip3 install flake8


COPY . .

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

 
# create data directory
ENV DATA_DIR /data
RUN mkdir "$DATA_DIR"
 
 
# install config
ENV CONFIG_FILE=${HOME}/.bitcoin/bitcoin.conf
COPY bitcoin.conf "$CONFIG_FILE"

# locale / text encodings
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
 

# CMD bitcoind -printtoconsole -conf="$CONFIG_FILE" -datadir="$DATA_DIR"
CMD bash
