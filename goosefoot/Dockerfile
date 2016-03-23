FROM gosmart/goosefoot-mesher-base

ENV GSSF_ELMER_COMMIT 1d621de3933435210b05d30d0142bfbaac30cc47
RUN cd /usr/src && git clone https://github.com/go-smart/gssf-elmer.git elmer && cd elmer && git checkout ${GSSF_ELMER_COMMIT}

RUN mkdir -p /opt/elmer

WORKDIR /opt/elmer

ENV GSSF_ELMER_PREFIX=/usr/local
RUN cmake /usr/src/elmer -DCMAKE_INSTALL_PREFIX=${GSSF_ELMER_PREFIX}

RUN make

RUN make install

ENV GSSF_LIBNUMA_COMMIT 334c3bb
RUN cd /usr/local/src && git clone https://github.com/go-smart/gssf-elmer-modules.git elmer-libnuma && cd elmer-libnuma && git checkout ${GSSF_LIBNUMA_COMMIT}

RUN mkdir -p /tmp/elmer-libnuma-build

WORKDIR /tmp/elmer-libnuma-build

RUN cmake /usr/local/src/elmer-libnuma -DCMAKE_INSTALL_PREFIX=${GSSF_ELMER_PREFIX}

RUN make && make install

# Remake GSSF to ensure Elmer is recognised
RUN rm -rf /tmp/gssf-build && mkdir -p /tmp/gssf-build

WORKDIR /tmp/gssf-build

RUN cmake /usr/local/src/gssf

RUN make && make install

ENV GSSA_CONTAINER_MODULE_COMMIT=9da0a5f
RUN pip3 install git+https://github.com/go-smart/gssa-container-module@$GSSA_CONTAINER_MODULE_COMMIT

RUN mkdir -p /var/run/gssf /shared

RUN chown -R gssf:gssf /var/run/gssf
RUN chown -R gssf:gssf /shared

WORKDIR /var/run/gssf

COPY env.sh /

USER gssf

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENTRYPOINT ["/env.sh"]
