# docker-tor

Docker image for [Tor].

This image is also on [Docker Hub].

## Getting the image

You have two options to get the image:

1. Build it yourself with `make build`.
2. Download it via `docker pull onehostcloud/docker-tor` ([automated build][Docker Hub])

[Tor]: https://www.torproject.org/
[Docker Hub]: https://hub.docker.com/r/onehostcloud/docker-tor/

### How to use this image

`$ docker run --name some-docker-tor -d onehostcloud/docker-tor`

The following **environment variables are required** to get container correctly works:

-e TOR_SERVICE_<service_name>=<tor_publish_port>:<linked_container_name>:<linked_container_service_port>

You can set:
- *service_name*: simple alias, e.g. wordpress, web, myservice, etc.
- *tor_publish_port*: a public service port, e.g. 80, 443, etc.
- *linked_container_name*: name of the linked container (docker links are deprecated anyway) or container name in the same network (reachable)
- *linked_container_service_port*: exposed port of the linked container, e.g. 80, 443, etc. Linked container must expose that port to Tor container

The defined service will be published via a random Onion address, you can identify by looking into container logs:

`$ docker logs -f some--docker-tor`

You can define multiple services to publish in Tor network by defining multiple TOR_SERVICE_<exampleX> environment variables. Each one will get a different random Onion address.

To get the same Onion address for multiple internal services a more long environment variable need to be defined, using a comma-separated notation without whitespaces, like below:

-e TOR_SERVICE_<service_name>=<tor_publish_port1>:<linked_container1_name>:<linked_container1_service_port>,<tor_publish_port2>:<linked_container2_name>:<linked_container2_service_port>,etc.

A valid example:

-e TOR_SERVICE_wordpress=80:web:80,8080:phpmyadmin:80,4444:sftp:22

If the "TOR_SERVICE_example=..." env variable is not defined, Tor container will exit due to errors.

