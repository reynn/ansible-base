FROM fedora:25

WORKDIR /ansible

ARG ANSIBLE_VERSION=2.4.2.0

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      FEDORA_VERSION=25

RUN dnf install -vy \
        python \
        libffi-devel \
        openssl-devel \
        python-devel \
        redhat-rpm-config \
        gcc \
    && pip install --upgrade pip ansible==${ANSIBLE_VERSION} \
    && dnf remove -y \
        gcc \
        python-devel \
        libffi-devel \
        redhat-rpm-config \
    && rm -rf /var/cache/dnf

ENTRYPOINT [ "ansible-playbook" ]
