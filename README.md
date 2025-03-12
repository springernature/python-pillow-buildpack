# Cloud Foundry Python Buildpack with Pillow support libraries

This is a fork of the [Cloudfoundry Python Buildpack](https://github.com/cloudfoundry/python-buildpack) that adds extra libraries for more complete [Pillow](http://python-pillow.org)/[Pillow-SIMD](https://github.com/uploadcare/pillow-simd/) support.

You can use this via:
 ```bash
cf push my_app -b https://github.com/springernature/python-pillow-buildpack
 ```

The bundle libwebp was built on an Ubuntu 18.04.2 VM:
```bash
sudo apt-get install build-essential autoconf libtool
WEBP_VERSION=1.0.3
curl -Lso- https://github.com/webmproject/libwebp/archive/v$WEBP_VERSION.tar.gz | tar xzf -
cd libwebp-$WEBP_VERSION
./autogen.sh
./configure --prefix=/home/vcap/deps/0/libwebp && make
sudo rm -rf /home/vcap/deps/0/libwebp
sudo make install
tar czvf libwebp-$WEBP_VERSION-cflinuxfs3.tgz -C /home/vcap/deps/0/libwebp .
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
