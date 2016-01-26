Go-Smart Simulation Framework (GSSF)
====================================

**Primary authors** : [NUMA Engineering Services Ltd](http://www.numa.ie) (NUMA), Dundalk, Ireland

**Project website** : http://www.gosmart-project.eu/

This project is co-funded by: European Commission under grant agreement no. 600641.

This wraps [GSSF](https://github.com/go-smart/gssf) to provide a GSSA-compatible container that also
runs stand-alone when given the `--override` flag.

Installation
------------

In this directory, run:

```sh
    sudo docker build -t numaengineering/gssf-mesher-base gssf-mesher-base
    sudo docker build -t numaengineering/gssf gssf
```

Usage
-----

In stand-alone mode, you can use this container with the command:

```sh
    sudo docker run -v $DIR:/shared -t numaengineering/gssf --override
```

where `$DIR` is a directory containing an `input/` folder with all necessary input surfaces for
GSSF and a `settings.xml` file. Note that GSSF will run as an unprivileged user, so permissions
should be set accordingly for writing within `$DIR`.

As part of GSSA, this container is a known image corresponding to the `elmer-libnuma` family,
so no additional configuration should be required.
