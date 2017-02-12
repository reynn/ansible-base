node {
  stage('Checkout from GitHub') {
    checkout scm
  }

  def parallelBuilds = [:]

  stage('Setup') {
    String ansibleVersion = "2.2.1.0"
    List dockerDistros = ["ubuntu", "alpine", "centos"]

    for (distro in dockerDistros) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      if (dockerfileExists) {
        parallelBuilds[distro] = {
          docker.build("reynn/ansible:${ansibleVersion}-alpine", "-f Dockerfile-alpine --build-arg 'ANSIBLE_VERSION=${ansibleVersion}' .")
        }
      }
    }
  }

  stage('Build Docker images') {
    parallel parallelBuilds
  }

  stage('Cleanup') {
    deleteDir()
  }
}
