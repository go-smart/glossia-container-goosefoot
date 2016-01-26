FROM ubuntu:15.10

RUN adduser --system --quiet --home /var/run/gssf --no-create-home --shell /bin/false --group --gecos "Go-Smart Simulation Framework" gssf

RUN apt-get update

RUN apt-get install -y python python-pip python3 python3-pip libjsoncpp-dev cmake python3-yaml git python3-lxml software-properties-common \
        python-vtk libcgal-dev swig wget python-dev libvtk5-dev autoconf automake libtool curl libboost-filesystem-dev gmsh python3-numpy \
        python3-jinja2 libtinyxml2-dev python-numpy python-lxml

RUN pip install slugify

RUN pip3 install hachiko

RUN apt-get build-dep -y liboce-visualization-dev elmer

RUN apt-get install -y gdb # RMV

RUN cd /usr/local/src && wget https://github.com/tpaviot/oce/archive/OCE-0.16.1.tar.gz && tar -xzf OCE-0.16.1.tar.gz && mkdir /tmp/oce-build

WORKDIR /tmp/oce-build

RUN cmake /usr/local/src/oce-OCE-0.16.1

RUN make && make install

RUN cd /usr/local/src && git clone https://github.com/tpaviot/pythonocc-core.git

RUN mkdir /tmp/pythonocc-core-build

WORKDIR /tmp/pythonocc-core-build

RUN cmake /usr/local/src/pythonocc-core -DPYTHON_INCLUDE_DIR=/usr/include/python2.7 -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython2.7.so

RUN make && make install

ENV GSSF_ELMER_COMMIT 1d621de3933435210b05d30d0142bfbaac30cc47
RUN cd /usr/src && git clone https://github.com/go-smart/gssf-elmer.git elmer && cd elmer && git checkout ${GSSF_ELMER_COMMIT}

RUN mkdir -p /opt/elmer

WORKDIR /opt/elmer

ENV GSSF_ELMER_PREFIX=/usr/local
RUN cmake /usr/src/elmer -DCMAKE_INSTALL_PREFIX=${GSSF_ELMER_PREFIX}

RUN make

RUN make install

RUN curl -SL https://github.com/google/protobuf/releases/download/v3.0.0-beta-2/protobuf-cpp-3.0.0-beta-2.tar.gz | tar -xzC /usr/local/src

RUN mkdir -p /tmp/protobuf-cpp-build

WORKDIR /tmp/protobuf-cpp-build

RUN /usr/local/src/protobuf-3.0.0-beta-2/configure

RUN make

# Should fail on Ruby test (1 FAIL)
#RUN make check

RUN make install && ldconfig

ENV GSSF_MESHER_CGAL_COMMIT=ea6eeda
RUN cd /usr/local/src && git clone https://github.com/go-smart/gssf-mesher-cgal.git gssf-mesher-cgal && cd gssf-mesher-cgal && git checkout ${GSSF_MESHER_CGAL_COMMIT}

RUN mkdir -p /tmp/mesher-cgal-build

WORKDIR /tmp/mesher-cgal-build

RUN cmake /usr/local/src/gssf-mesher-cgal

RUN make && make install

ENV GSSF_LIBNUMA_COMMIT 646a4ff
RUN cd /usr/local/src && git clone https://github.com/go-smart/gssf-elmer-modules.git elmer-libnuma && cd elmer-libnuma && git checkout ${GSSF_LIBNUMA_COMMIT}

RUN mkdir -p /tmp/elmer-libnuma-build

WORKDIR /tmp/elmer-libnuma-build

RUN cmake /usr/local/src/elmer-libnuma -DCMAKE_INSTALL_PREFIX=${GSSF_ELMER_PREFIX}

RUN make && make install

ENV GSSA_CONTAINER_MODULE_COMMIT=d921981
RUN pip3 install git+https://github.com/go-smart/gssa-container-module@$GSSA_CONTAINER_MODULE_COMMIT

ENV GSSF_COMMIT=8884920
RUN cd /usr/local/src && git clone https://github.com/go-smart/gssf.git gssf && cd gssf && git checkout ${GSSF_COMMIT}

RUN mkdir -p /tmp/gssf-build

WORKDIR /tmp/gssf-build

RUN cmake /usr/local/src/gssf

RUN make && make install

RUN mkdir -p /var/run/gssf /shared

RUN chown -R gssf:gssf /var/run/gssf
RUN chown -R gssf:gssf /shared

WORKDIR /var/run/gssf

COPY env.sh /

USER gssf

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENTRYPOINT ["/env.sh"]
