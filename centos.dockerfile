ARG CENTOS_VERSION=7
ARG ANSIBLE_VERSION=2.3.0.0

FROM centos:$CENTOS_VERSION

LABEL ANSIBLE_VERSION=$ANSIBLE_VERSION \
      CENTOS_VERSION=$CENTOS_VERSION

WORKDIR /ansible

RUN yum install -y epel-release \
    && yum install -y \
        python \
        python-pip \
        python-devel \
        gcc \
        libffi-devel \
        openssl-devel \
    && pip install -U pip  ansible==${ANSIBLE_VERSION}

ENTRYPOINT [ "ansible-playbook" ]
