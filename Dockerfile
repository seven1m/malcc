FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y -q \
  build-essential \
  gdb \
  libedit-dev \
  libgc-dev \
  libpcre3-dev \
  python \
  valgrind \
  wget

RUN cd /tmp && \
    wget http://eradman.com/entrproject/code/entr-4.1.tar.gz && \
    tar xzf entr-4.1.tar.gz && \
    cd eradman-entr-* && \
    ./configure && \
    make install

WORKDIR /malcc

CMD ["bash"]
