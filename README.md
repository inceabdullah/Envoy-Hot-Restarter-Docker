# Envoy Hot Restarter Docker

This repository provides a Docker image for running Envoy with the hot-restart feature enabled using the `hot-restart.py` script. The `hot-restart.py` script is executed as part of the `entrypoint.sh`. This image allows you to easily configure and launch Envoy with the desired parameters.

## Features

- Automatically runs `hot-restart.py` in the background.
- Adds parameters such as `--restart-epoch $RESTART_EPOCH --drain-time-s 10 -l debug --parent-shutdown-time-s 15` to the Envoy command.
- Supports configuration file sharing via a mounted folder.

## Build the Docker Image

You can build the Docker image using the following command:

```bash
docker build . -t envoy-hot-restart
```

## Example Usage

To start Envoy using this Docker image, you can use a command like the following:

```bash
docker run -e ENVOY_UID=0 -e ENVOY_GID=0 \
    --restart always -dit --ipc host -v /dev:/dev \
    --net host \
    -v $PWD/certs:/certs \
    -v $PWD/logs:/var/log \
    -v $PWD/etc-envoy:/etc/envoy \
    --name envoy \
    envoy-hot-restart -c /etc/envoy/envoy.yaml --component-log-level upstream:debug,connection:trace
```

**Note**: The `envoy.yaml` configuration file is shared in a folder because it cannot be modified within the container directly, as shown in the example above. You should place your `envoy.yaml` file in the `etc-envoy` directory on your host machine.

## Restarting Envoy

To gracefully restart Envoy using the hot-restart feature, you can send the `HUP` signal to the container:

```bash
docker kill envoy --signal HUP
```

This will trigger the hot restart process, allowing Envoy to update its configuration without disrupting ongoing connections.

## Testing

To test the Envoy configuration, you can use the following test script:

```bash
# Switch Envoy to listen on port 8081
sed 's/8080/8081/' -i etc-envoy/envoy.yaml
docker kill envoy --signal HUP
curl 0

# Switch Envoy back to listen on port 8080
sed 's/8081/8080/' -i etc-envoy/envoy.yaml
docker kill envoy --signal HUP
curl 0
```

This test script demonstrates how to change the port Envoy listens on and trigger a hot restart to apply the configuration changes. Make sure to adapt it to your specific use case if needed.

Feel free to contribute to this project and report any issues or improvements!
