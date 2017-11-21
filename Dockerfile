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

COPY ./torrc /etc/torrc
RUN chown debian-tor:debian-tor /etc/torrc

COPY ./get-tor-hostnames /usr/local/bin/get-tor-hostnames
COPY ./docker-entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
#EXPOSE 9001
USER debian-tor
CMD /usr/bin/tor -f /etc/torrc
