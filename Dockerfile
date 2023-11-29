FROM debian:bullseye-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    lib32gcc-s1 \
    lib32stdc++6 \
    wget \
    ca-certificates \
    rsync \
    unzip \
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
    wait-for-it \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g 999 warfork && useradd -r -m -g warfork -u 999 warfork

USER warfork

RUN mkdir /home/warfork/Steam

WORKDIR /home/warfork/Steam

RUN wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxf -

RUN /home/warfork/Steam/steamcmd.sh +quit

WORKDIR /home/warfork

RUN mkdir server

COPY entrypoint.sh /usr/local/bin/

COPY entrypointtv.sh /usr/local/bin/

WORKDIR /home/warfork/server/Warfork.app/Contents/Resources

CMD [ "bash", "/usr/local/bin/entrypoint.sh" ]