FROM ubuntu:16.04

ARG RELEASE=40

ENV LANG=C.UTF-8
ENV MCROUTER_DIR            /usr/local/mcrouter
ENV MCROUTER_REPO           https://github.com/facebook/mcrouter.git
ENV MCROUTER_TAG            release-$RELEASE-0
ENV DEBIAN_FRONTEND         noninteractive
ENV MAKE_ARGS               -j8

ADD clean_ubuntu_16.04.sh /tmp

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git sudo netcat && \
    mkdir -p $MCROUTER_DIR/repo && \
    cd $MCROUTER_DIR/repo && git clone $MCROUTER_REPO && \
    cd $MCROUTER_DIR/repo/mcrouter  && git checkout $MCROUTER_TAG && \
    cd $MCROUTER_DIR/repo/mcrouter/mcrouter/scripts && \
    ./install_ubuntu_16.04.sh $MCROUTER_DIR $MAKE_ARGS && \
    /tmp/clean_ubuntu_16.04.sh $MCROUTER_DIR && rm -rf $MCROUTER_DIR/repo && \
    apt-get clean &&  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -s $MCROUTER_DIR/install/bin/mcrouter /usr/local/bin/mcrouter && \
    mkdir -p /var/spool/mcrouter /var/mcrouter && chgrp -R 0 /var/spool/mcrouter /var/mcrouter && \
    chmod -R g=u /var/spool/mcrouter /var/mcrouter

ENV DEBIAN_FRONTEND newt

USER 1001