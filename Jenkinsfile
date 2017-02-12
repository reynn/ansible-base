node {
  stage('Checkout from GitHub') {
    checkout scm
  }

  String ansibleVersion = "2.2.1.0"
  List dockerDistros = ["ubuntu", "alpine", "centos"]

  def parallelBuilds = [:]

  for (distro in dockerDistros) {
    def dockerfileExists = fileExists "Dockerfile-${distro}"
    if (dockerfileExists) {
      parallelBuilds[dockerImage] = docker.build("reynn/ansible:${ansibleVersion}-alpine",
                                               "-f Dockerfile-alpine --build-arg 'ANSIBLE_VERSION=${ansibleVersion}' .")
    }
  }

  parallel parallelBuilds

  deleteDir()
}
