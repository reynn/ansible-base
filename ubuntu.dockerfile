FROM ubuntu:17.04

WORKDIR /ansible

ARG ANSIBLE_VERSION=2.3.0.0

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      UBUNTU_VERSION=17.04

RUN apt update \
    && apt install -y \
        python \
        python-pip \
        libffi-dev \
        libssl-dev \
        python-dev \
    && pip install --upgrade pip ansible==${ANSIBLE_VERSION}

ENTRYPOINT [ "ansible-playbook" ]
