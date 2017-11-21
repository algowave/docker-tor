FROM debian:jessie
MAINTAINER "onehostcloud.hosting <ben@onehostcloud.hosting>"

ENV DEBIAN_FRONTEND noninteractive
ADD apt-pinning /etc/apt/preferences.d/pinning
RUN echo 'deb http://deb.torproject.org/torproject.org jessie main' > /etc/apt/sources.list.d/tor.list && \
    gpg --keyserver keys.gnupg.net --recv 886DDD89 && \
    gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
RUN apt-get update && apt-get install -y \
    deb.torproject.org-keyring \
    obfsproxy \
    openssl \
    tor

VOLUME /var/lib/tor
ADD ./torrc /etc/torrc
ADD ./get-tor-hostnames /usr/local/bin/get-tor-hostnames

# Generate a random nickname for the relay
RUN echo "Nickname docker$(head -c 16 /dev/urandom  | sha1sum | cut -c1-10)" >> /etc/torrc

ADD ./docker-entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9001
CMD /usr/local/bin/tor -f /etc/torrc
