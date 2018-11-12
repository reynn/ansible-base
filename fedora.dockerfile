FROM fedora:29

WORKDIR /ansible

ARG ANSIBLE_VERSION=2.7.1.0

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      FEDORA_VERSION=29

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
