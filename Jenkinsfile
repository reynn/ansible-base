#!/usr/bin/env groovy

def sendSlackMessage = {
  msg = '', msgColor = 'good' ->
    slackSend color: msgColor, message: msg, tokenCredentialId: '29731667-bfb1-433d-8dc1-f76d2a69c226'
}

node('docker') {

  stage('Checkout from GitHub') {
    checkout scm
  }

  // Variables
  String ansibleVersion = "2.2.1.0"
  def parallelBuilds = [:]
  List dockerImages = []

  stage('Setup') {

    List dockerDistros = ["ubuntu", "alpine", "centos", "fedora25"]
    stash includes: 'Dockerfile*', name: 'dockerfiles'

    for (distro in dockerDistros) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      if (dockerfileExists) {
        parallelBuilds[distro] = {
          node {
            unstash 'dockerfiles'

            dockerImages.add(dockerImages.add(docker.build("reynn/ansible:${ansibleVersion}-${distro}",
              "-f Dockerfile-${distro} --no-cache --build-arg 'ANSIBLE_VERSION=${ansibleVersion}' .")))
          }
        }
      }
    }
  }

  try {
    stage('Build Docker images') {
      parallel parallelBuilds
    }

    stage('Publish Docker images to hub.docker.com') {
      docker.withRegistry('', '54154007-6bac-4f89-be72-c253834b539a') {
        for (image in dockerImages) {
          image.push()
        }
      }
    }

    currentBuild.result = 'SUCCESS'
    sendSlackMessage("Successfully built ${JOB_NAME}\nAnsible Version: ${ansibleVersion}\nDuration: ${currentBuild.duration}")
  } catch (Exception ex) {
    currentBuild.result = 'FAILURE'
    sendSlackMessage("Failed to build ${JOB_NAME}: ${ex.message}", 'warning')
  }
}
