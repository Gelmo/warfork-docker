FROM debian:bookworm-slim

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
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r -g 999 warfork && useradd -r -m -g warfork -u 999 warfork

USER warfork

RUN mkdir /home/warfork/Steam && \
    mkdir /home/warfork/server

WORKDIR /home/warfork/Steam

RUN wget -qO- https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar zxf - \
    && /home/warfork/Steam/steamcmd.sh +quit

COPY entrypoint.sh /usr/local/bin/

COPY entrypointtv.sh /usr/local/bin/

WORKDIR /home/warfork/server

CMD [ "bash", "/usr/local/bin/entrypoint.sh" ]