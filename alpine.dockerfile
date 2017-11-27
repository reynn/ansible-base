FROM alpine:3.6

WORKDIR /ansible

ARG ANSIBLE_VERSION=2.3.2.0

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      ALPINE_VERSION=3.6

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
    && pip install --upgrade pip ansible==${ANSIBLE_VERSION} \
    && apk del build-deps

ENTRYPOINT [ "ansible-playbook" ]
