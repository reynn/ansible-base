FROM alpine:3.8

WORKDIR /ansible

ARG ANSIBLE_VERSION=2.7.1.0

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      ALPINE_VERSION=3.8

RUN apk add --update --no-cache \
        python \
        py-pip \
        libffi \
        openssl-dev \
        ca-certificates \
    && apk add --update --no-cache --virtual build-deps \
        python-dev \
        build-base \
        libffi-dev \
    && pip install -U pip \
    && pip install ansible==${ANSIBLE_VERSION} \
    && apk del build-deps

ENTRYPOINT [ "ansible-playbook" ]
