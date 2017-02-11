FROM alpine:3.4

WORKDIR /ansible

RUN apk add --update --no-cache \
        python \
        py-pip \
        libffi \
        openssl-dev \
    && apk add --update --no-cache --virtual build-deps \
        python-dev \
        build-base \
        libffi-dev \
    && pip install --upgrade pip \
    && pip install --upgrade ansible \
    && apk del build-deps

ENTRYPOINT [ "ansible" ]
