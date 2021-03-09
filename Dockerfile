# FROM alpine:3.12
FROM alpine:latest

ARG VERSION=0.18.0

ENV INSTANCE_NAME=searx \
    AUTOCOMPLETE= \
    LANGUAGE=en-US \
    BASE_URL=False \
    IMAGE_PROXY=False  \
    DEFAULT_LOCALE= \
    UID=991 GID=991

RUN apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
    python3-dev \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    tar \
    ca-certificates \
 && apk add \
    su-exec \
    python3 \
    py3-pip \
    libxml2 \
    libxslt \
    openssl \
    tini \
 && mkdir /usr/local/searx && cd /usr/local/searx \
 && wget -qO- https://github.com/asciimoo/searx/archive/v${VERSION}.tar.gz | tar xz --strip 1 \
 && pip3 install --upgrade setuptools pip \
 && pip3 install --no-cache -r requirements.txt \
 \
 # Fix deprecated werkzeug import
 && pip3 uninstall --yes Werkzeug \
 && pip3 install Werkzeug==0.16.0 \
 \
 && sed -i "s/127.0.0.1/0.0.0.0/g" searx/settings.yml \
 && apk del build-dependencies \
 && rm -f /var/cache/apk/*

COPY run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8888

LABEL maintainer="deichking <info@deichking.de>"

CMD ["run.sh"]
