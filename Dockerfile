FROM debian:bookworm-slim

RUN echo "Unique string to improperly force a fresh build at docker hub - v2"

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
    python3 \
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
    cron \
    sudo \
    vim \
    locales \
    gdb \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r -g 999 warfork && useradd -r -m -g warfork -u 999 warfork

RUN ulimit -c unlimited \
    && mkdir -p /tmp/core

USER warfork

RUN mkdir -p /home/warfork/Steam && \
    mkdir -p /home/warfork/server && \
    mkdir -p /home/warfork/.steam

WORKDIR /home/warfork/Steam

RUN wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxf - \
    && /home/warfork/Steam/steamcmd.sh +quit

RUN ln -s /home/warfork/Steam/linux64 /home/warfork/.steam/sdk64 && \
    ln -s /home/warfork/Steam/linux32 /home/warfork/.steam/sdk32

COPY entrypoint.sh /usr/local/bin/

COPY entrypointtv.sh /usr/local/bin/

CMD [ "bash", "/usr/local/bin/entrypoint.sh" ]