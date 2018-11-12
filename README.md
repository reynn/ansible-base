# Ansible Docker Images

## Build Statuses (Quay.io)

| Image   | Base Version  | Status |
|---------|---------------|--------|
| Alpine  | 3.8           | [![ansible-alpine](https://quay.io/repository/reynn/ansible-alpine/status "ansible-alpine")](https://quay.io/repository/reynn/ansible-alpine) |
| CentOS  | 7             | [![ansible-centos](https://quay.io/repository/reynn/ansible-centos/status "ansible-centos")](https://quay.io/repository/reynn/ansible-centos) |
| Fedora  | 29            | [![ansible-fedora](https://quay.io/repository/reynn/ansible-fedora/status "ansible-fedora")](https://quay.io/repository/reynn/ansible-fedora) |
| Ubuntu  | 18.10         | [![ansible-ubuntu](https://quay.io/repository/reynn/ansible-ubuntu/status "ansible-ubuntu")](https://quay.io/repository/reynn/ansible-ubuntu) |

## Description

Various editions of containers for Ansible. Very basic packages installed so if more or need use this as a base in a new Dockerfile.

## Usage

* Pull desired image, `docker pull quay.io/reynn/ansible-alpine:2.4.6.0`.
* Run image please mount desired playbooks/inventory data to `/ansible`,
  ```bash
  docker run -v "$(pwd):/ansible:rw" quay.io/reynn/ansible-alpine:2.4.6.0 -i inventories/hosts.yml playbooks/docker-host.yml
  ```
