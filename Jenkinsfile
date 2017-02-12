node {
  stage('Checkout from GitHub') {
    checkout scm
  }

  String ansibleVersion = "2.2.1.0"
  List dockerImages = ["ubuntu", "alpine", "centos"]

  def builtImage = docker.build("reynn/ansible:${ansibleVersion}-alpine",
    "-f Dockerfile-alpine --build-arg 'ANSBILE_VERSION=${ansibleVersion}' .")

  deleteDir()
}
