ARG ALPINE_VERSION=3.6
ARG ANSIBLE_VERSION=2.3.0.0

FROM alpine:$ALPINE_VERSION

WORKDIR /ansible

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      ALPINE_VERSION=$ALPINE_VERSION

RUN apk add --update --no-cache \
        python \
        py-pip \
        libffi \
        openssl-dev \
    && apk add --update --no-cache --virtual build-deps \
        python-dev \
        build-base \
        libffi-dev \
    && pip install --upgrade pip ansible==${ANSIBLE_VERSION} \
    && apk del build-deps

ENTRYPOINT [ "ansible-playbook" ]
