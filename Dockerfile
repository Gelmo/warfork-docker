FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    lib32gcc1=1:8.3.0-6 \
    lib32stdc++6=8.3.0-6 \
    wget=1.20.1-1.1 \
    ca-certificates=20190110 \
    rsync=3.1.3-6 \
    unzip=6.0-23+deb10u1 \
    tmux \
    jq \
    bc \
    binutils \
    ca-certificates \
    util-linux \
    python \
    curl \
    wget \
    file \
    tar \
    bzip2 \
    gzip \
    unzip \
    bsdmainutils \
    libcurl4 \
    libcurl3-gnutls \
    libcurl4-gnutls-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m warfork

USER warfork

RUN mkdir /home/warfork/Steam

WORKDIR /home/warfork/Steam

RUN wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxf -

RUN /home/warfork/Steam/steamcmd.sh +quit

WORKDIR /home/warfork

RUN mkdir server

COPY entrypoint.sh /usr/local/bin/

CMD [ "bash", "/usr/local/bin/entrypoint.sh" ]