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
