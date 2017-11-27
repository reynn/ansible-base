FROM centos:7

WORKDIR /ansible

ARG ANSIBLE_VERSION=2.3.2.0

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      CENTOS_VERSION=7

RUN yum install -y epel-release \
    && yum install -y \
        python \
        python-pip \
        python-devel \
        gcc \
        libffi-devel \
        openssl-devel \
    && pip install -U pip  ansible==${ANSIBLE_VERSION} \
    && rm -rf /var/cache/yum

ENTRYPOINT [ "ansible-playbook" ]
