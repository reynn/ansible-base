node {
  stage('Checkout from GitHub') {
    checkout scm
  }

  def parallelBuilds = [:]
  List dockerImages = []

  stage('Setup') {
    String ansibleVersion = "2.2.1.0"
    List dockerDistros = ["ubuntu", "alpine", "centos"]

    for (distro in dockerDistros) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      if (dockerfileExists) {
        parallelBuilds[distro] = {
          dockerImages.add(docker.build("reynn/ansible:${ansibleVersion}-${distro}", "-f Dockerfile-${distro} --build-arg 'ANSIBLE_VERSION=${ansibleVersion}' ."))
        }
      }
    }
  }

  stage('Build Docker images') {
    parallel parallelBuilds
  }

  stage('Cleanup') {
    deleteDir()
    for (dockerImage in dockerImages) {
      println "Deleting :: ${dockerImage}"
      sh "docker image rm -f ${dockerImage}"
    }
  }
}
