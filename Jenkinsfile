#!/usr/bin/env groovy

@Library("pipelineLibraries")

node('docker') {

  def pipeline = new net.reynn.Utilities()

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

    if (env.BRANCH_NAME == 'master') {
      stage('Publish Docker images to hub.docker.com') {
        for (image in dockerImages) {
          println "------------------- Image name: ${image.id} -------------------"
          image.inside {
            sh "cat /etc/*release"
          }
          pipeline.pushDockerImage(image)
        }
      }
    }

    currentBuild.result = 'SUCCESS'
    pipeline.sendSlackMessage("Successfully built ${JOB_NAME}\nAnsible Version: ${ansibleVersion}\nDuration: ${currentBuild.duration}")
  } catch (Exception ex) {
    currentBuild.result = 'FAILURE'
    pipeline.sendSlackMessage("Failed to build ${JOB_NAME}: ${ex.message}", 'warning')
  }
}
