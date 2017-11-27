ARG FEDORA_VERSION=7
ARG ANSIBLE_VERSION=2.3.0.0

FROM fedora:$FEDORA_VERSION

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      FEDORA_VERSION=$FEDORA_VERSION

WORKDIR /ansible

RUN dnf install -vy \
      python \
      libffi-devel \
      openssl-devel \
      python-devel \
      redhat-rpm-config \
      gcc \
    && pip install --upgrade pip ansible==${ANSIBLE_VERSION} \
    && dnf remove -y gcc \
      openssl-devel \
      python-devel

ENTRYPOINT [ "ansible-playbook" ]
