#!/usr/bin/env groovy

// available to view at https://github.com/reynn/jenkins-pipeline
@Library("pipelineLibraries")_

buildDocker {
  stage('Checkout from GitHub') {
    checkout scm
  }

  // Variables
  String ansibleVersion = "2.2.1.0"
  def parallelBuilds = [:]
  List dockerImageNames = []

  stage('Setup') {

    List dockerDistros = ["alpine"]
    stash includes: 'Dockerfile*', name: 'dockerfiles'

    for (distro in dockerDistros) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      if (dockerfileExists) {
        parallelBuilds[distro] = {
          node {
            unstash 'dockerfiles'
            String imageName = "reynn/ansible:${ansibleVersion}-${distro}"
            docker.build(imageName, "-f Dockerfile-${distro} --build-arg 'ANSIBLE_VERSION=${ansibleVersion}' .")

            dockerImageNames.add(imageName)
          }
        }
      }
    }
  }

  stage('Build Docker images') {
    parallel parallelBuilds
  }

  if (env.BRANCH_NAME == 'master') {
    stage('Publish Docker images to hub.docker.com') {
      for (imageName in dockerImageNames) {
        println "------------------- Image name: ${imageName} -------------------"
        docker.image(imageName).inside {
          sh "cat /etc/*release"
        }
        withRegistry('nexus.reynn.net', 'reynn-docker-repo-creds') {
          docker.image(imageName).push()
        }
      }
    }
  }

  currentBuild.result = 'SUCCESS'
  sendSlackMessage("Successfully built ${JOB_NAME}\nAnsible Version: ${ansibleVersion}\nDuration: ${currentBuild.duration}")
}
