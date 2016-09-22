FROM debian:jessie

MAINTAINER Patricio Bruna <pbruna@zboxapp.com>

# First install Dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
       curl \
       coturn \
       python-lxml \
       python-jinja2 \
       python-bleach \
    && apt-get clean cache

RUN curl -k https://matrix.org/packages/debian/repo-key.asc | apt-key add - \
    && echo "deb http://matrix.org/packages/debian jessie main" > /etc/apt/sources.list.d/matrix.list \
    && apt-get update \
    && apt-get install -y matrix-synapse \
       matrix-synapse-angular-client \
       python-ldap3 \
       pwgen \
    && apt-get remove -y perl perl-modules libgdbm3 javascript-common \
    && apt-get clean cache \
    && echo "synapse: `dpkg-query --showformat='${Version}' --show matrix-synapse`" >> /synapse.version \
    && echo "coturn: `dpkg-query --showformat='${Version}' --show coturn`" >> /synapse.version

COPY adds/start.sh /start.sh
RUN chmod a+x /start.sh
RUN mkdir -p /data

# startup configuration
ENTRYPOINT ["/start.sh"]
CMD ["start"]
EXPOSE 8448
VOLUME ["/data"]
