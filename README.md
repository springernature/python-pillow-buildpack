# Cloud Foundry Python Buildpack with Pillow support libraries

This is a fork of the [Cloudfoundry Python Buildpack](https://github.com/cloudfoundry/python-buildpack) that adds extra libraries for more complete [Pillow](http://python-pillow.org)/[Pillow-SIMD](https://github.com/uploadcare/pillow-simd/) support.

We've also added libexiv2 and libboost-python in order to support py3exiv2, for image metadata manipulation.

You can use this via:
 ```bash
cf push my_app -b https://github.com/springernature/python-pillow-buildpack
 ```

## Genereration of library binaries

### libwebp

The bundle libwebp was built on an Ubuntu 18.04.5 VM:
```bash
sudo apt install build-essential autoconf libtool
WEBP_VERSION=1.2.1
curl -Lso- https://github.com/webmproject/libwebp/archive/v$WEBP_VERSION.tar.gz | tar xzf -
cd libwebp-$WEBP_VERSION
./autogen.sh
./configure --prefix=/home/vcap/deps/0/libwebp && make
sudo rm -rf /home/vcap/deps/0/libwebp
sudo make install
tar czvf libwebp-$WEBP_VERSION-cflinuxfs3.tgz -C /home/vcap/deps/0/libwebp .
```

### libexiv2
Steps to generate the included `exiv2-0.27.5-cflinuxfs3.tgz` (carried out in an Ubuntu 18.04.6):

Download and decompress sources ([Exiv2 Download page](https://exiv2.org/download.html)).
```bash
vagrant@vagrant:~/dev$ wget https://github.com/Exiv2/exiv2/releases/download/v0.27.5/exiv2-0.27.5-Source.tar.gz
[...]
vagrant@vagrant:~/dev$ sha256sum exiv2-0.27.5-Source.tar.gz 
35a58618ab236a901ca4928b0ad8b31007ebdc0386d904409d825024e45ea6e2  exiv2-0.27.5-Source.tar.gz
vagrant@vagrant:~/dev$ tar xf exiv2-0.27.5-Source.tar.gz 
vagrant@vagrant:~/dev$ cd exiv2-0.27.5-Source/
```
Follow [Exiv2 instructions for compiling for Linux](https://github.com/Exiv2/exiv2/tree/v0.27.5#5-1):
```bash
vagrant@vagrant:~/dev/exiv2-0.27.5-Source$ sudo apt --yes update
[...]
vagrant@vagrant:~/dev/exiv2-0.27.5-Source$ sudo apt install --yes build-essential git clang ccache python3 libxml2-utils cmake python3 libexpat1-dev libz-dev zlib1g-dev libssh-dev libcurl4-openssl-dev libgtest-dev google-mock
vagrant@vagrant:~/dev/exiv2-0.27.5-Source$ mkdir build ; cd build ;
vagrant@vagrant:~/dev/exiv2-0.27.5-Source/build$ cmake -DCMAKE_INSTALL_PREFIX=$PWD/../target .. -G "Unix Makefiles"
[...]
-- ------------------------------------------------------------------
-- CMake Generator:   Unix Makefiles
-- CMAKE_BUILD_TYPE:  
-- Compiler info: GNU (/usr/bin/c++) ; version: 7.5.0
-- CMAKE_CXX_STANDARD:
--  --- Compiler flags --- 
-- General:           
	 -fstack-protector-strong
	 -Wp,-D_GLIBCXX_ASSERTIONS
	 -Wall
	 -Wcast-align
	 -Wpointer-arith
	 -Wformat-security
	 -Wmissing-format-attribute
	 -Woverloaded-virtual
	 -W
-- Extra:              
-- Debug:             -g3 -gstrict-dwarf -O0
-- Release:           -O3 -DNDEBUG
-- RelWithDebInfo:    -O2 -g -DNDEBUG
-- MinSizeRel:        -Os -DNDEBUG
--  --- Linker flags --- 
-- General:           
-- Debug:             
-- Release:           
-- RelWithDebInfo:    
-- MinSizeRel:        
-- 
-- Compiler Options
-- Warnings as errors:                 NO
-- Use extra compiler warning flags:   NO
-- 
-- ------------------------------------------------------------------
-- Building shared library:            YES
-- Building PNG support:               YES
-- XMP metadata support:               YES
-- Building BMFF support:              NO
-- Native language support:            NO
-- Conversion of Windows XP tags:      YES
-- Nikon lens database:                YES
-- Building video support:             NO
-- Building webready support:          NO
-- Building exiv2 command:             YES
-- Building samples:                   YES
-- Building unit tests:                NO
-- Building doc:                       NO
-- Building with coverage flags:       NO
-- Using ccache:                       NO
[...]
vagrant@vagrant:~/dev/exiv2-0.27.5-Source/build$ make
[...]
vagrant@vagrant:~/dev/exiv2-0.27.5-Source/build$ make install
[...]
vagrant@vagrant:~/dev/exiv2-0.27.5-Source/build$ tar czvf exiv2-0.27.5-cflinuxfs3.tgz -C ../target .
[...]
vagrant@vagrant:~/dev/exiv2-0.27.5-Source/build$ sha256sum exiv2-0.27.5-cflinuxfs3.tgz 
0803f8152b8e176ab5b5aeb0c305f70c3ba25c67cc4e2cebba8d10ed14ef40f4  exiv2-0.27.5-cflinuxfs3.tgz
vagrant@vagrant:~/dev/exiv2-0.27.5-Source/build$ 
```

### libboost-python

```bash
vagrant@vagrant:~/dev$ wget https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz
[...]
vagrant@vagrant:~/dev$ sha256sum boost_1_80_0.tar.gz 
4b2136f98bdd1f5857f1c3dea9ac2018effe65286cf251534b6ae20cc45e1847  boost_1_80_0.tar.gz
vagrant@vagrant:~/dev$ tar xf boost_1_80_0.tar.gz
vagrant@vagrant:~/dev$ cd boost_1_80_0/
vagrant@vagrant:~/dev/boost_1_80_0$ sudo apt install build-essential python3-dev
[...]
vagrant@vagrant:~/dev/boost_1_80_0$ ./bootstrap.sh --prefix=$PWD/../boost-target --with-python-version=3.6 --with-python=/usr/bin/python3
[...]
vagrant@vagrant:~/dev/boost_1_80_0$ ./b2 --with-python install
[...]
Component configuration:

    - atomic                   : not building
    - chrono                   : not building
    - container                : not building
    - context                  : not building
    - contract                 : not building
    - coroutine                : not building
    - date_time                : not building
    - exception                : not building
    - fiber                    : not building
    - filesystem               : not building
    - graph                    : not building
    - graph_parallel           : not building
    - headers                  : not building
    - iostreams                : not building
    - json                     : not building
    - locale                   : not building
    - log                      : not building
    - math                     : not building
    - mpi                      : not building
    - nowide                   : not building
    - program_options          : not building
    - python                   : building
    - random                   : not building
    - regex                    : not building
    - serialization            : not building
    - stacktrace               : not building
    - system                   : not building
    - test                     : not building
    - thread                   : not building
    - timer                    : not building
    - type_erasure             : not building
    - wave                     : not building

...patience...
[...]
vagrant@vagrant:~/dev/boost_1_80_0$ sha256sum libboost-python-1.80.0-cflinuxfs3.tgz 
1f3c2600ebfdfa6aed1ddcc76c55487d05952631459d7a76ef874043f3532ea6  libboost-python-1.80.0-cflinuxfs3.tgz
```

# Cloud Foundry Python Buildpack

[![CF Slack](https://www.google.com/s2/favicons?domain=www.slack.com) Join us on Slack](https://cloudfoundry.slack.com/messages/buildpacks/)

A Cloud Foundry [buildpack](http://docs.cloudfoundry.org/buildpacks/) for Python based apps.

This buildpack supports running Django and Flask apps.

### Buildpack User Documentation

Official buildpack documentation can be found at [python buildpack docs](http://docs.cloudfoundry.org/buildpacks/python/index.html).

### Building the Buildpack

To build this buildpack, run the following commands from the buildpack's directory:

1. Source the .envrc file in the buildpack directory.

   ```bash
   source .envrc
   ```
   To simplify the process in the future, install [direnv](https://direnv.net/) which will automatically source .envrc when you change directories.

1. Install buildpack-packager

    ```bash
    go install github.com/cloudfoundry/libbuildpack/packager/buildpack-packager
    ```

1. Build the buildpack

    ```bash
    buildpack-packager build [ --cached=(true|false) ]
    ```

1. Use in Cloud Foundry

   Upload the buildpack to your Cloud Foundry and optionally specify it by name

    ```bash
    cf create-buildpack [BUILDPACK_NAME] [BUILDPACK_ZIP_FILE_PATH] 1
    cf push my_app [-b BUILDPACK_NAME]
    ```

### Testing

Buildpacks use the [Cutlass](https://github.com/cloudfoundry/libbuildpack/tree/master/cutlass) framework for running integration tests.

To test this buildpack, run the following commands from the buildpack's directory:
 
1. Source the .envrc file in the buildpack directory.

   ```bash
   source .envrc
   ```
   To simplify the process in the future, install [direnv](https://direnv.net/) which will automatically source .envrc when you change directories.

1. Run unit tests

    ```bash
    ./scripts/unit.sh
    ```

1. Run integration tests

   Buildpacks use the [Cutlass](https://github.com/cloudfoundry/libbuildpack/tree/master/cutlass) framework for running integration tests against Cloud Foundry. Before running the integration tests, you need to login to your Cloud Foundry using the [cf cli](https://github.com/cloudfoundry/cli):

    ```bash
    cf login -a https://api.your-cf.com -u name@example.com -p pa55woRD
    ```

   Note that your user requires permissions to run `cf create-buildpack` and `cf update-buildpack`. To run the integration tests, run the following command from the buildpack's directory:

    ```bash
    ./scripts/integration.sh
    ```
    
1. Note: To run the network tests, you must have Docker installed.   

### Contributing

Find our guidelines [here](./CONTRIBUTING.md).

### Help and Support

Join the #buildpacks channel in our [Slack community](http://slack.cloudfoundry.org/) if you need any further assistance.

### Reporting Issues

Open a GitHub issue on this project [here](https://github.com/cloudfoundry/python-buildpack/issues/new).

### Active Development

The project backlog is on [Pivotal Tracker](https://www.pivotaltracker.com/projects/1042066).
