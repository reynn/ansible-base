ARG UBUNTU_VERSION=17.04
ARG ANSIBLE_VERSION=2.3.0.0

FROM ubuntu:$UBUNTU_VERSION

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      UBUNTU_VERSION=$UBUNTU_VERSION

WORKDIR /ansible

RUN apt update \
    && apt install -y \
        python \
        python-pip \
        libffi-dev \
        libssl-dev \
        python-dev \
    && pip install --upgrade pip ansible==${ANSIBLE_VERSION}

ENTRYPOINT [ "ansible-playbook" ]
