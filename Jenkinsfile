#!/usr/bin/env groovy

// available to view at https://github.com/reynn/jenkins-pipeline
@Library("pipelineLibraries")_

// Variables
String ansibleVersion = '2.2.1.0'
String dockerRegistryUri = 'https://nexus.reynn.net'
def parallelBuilds = [:]
List dockerImageNames = []

nodeDocker {
  stage('Checkout from GitHub') {
    checkout scm
  }

  stage('Setup') {

    List dockerDistros = ["alpine", "ubuntu"]
    stash includes: 'Dockerfile*', name: 'dockerfiles'

    for (distro in dockerDistros) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      String imageName = "reynn/ansible:${ansibleVersion}-${distro}"
      if (dockerfileExists) {
        dockerImageNames.add(imageName)
        parallelBuilds[distro] = {
          node {
            unstash 'dockerfiles'
            def image = docker.build(imageName, "-f Dockerfile-${distro} --build-arg 'ANSIBLE_VERSION=${ansibleVersion}' .")
          }
        }
      }
    }
  }

  stage('Build Docker images') {
    parallel parallelBuilds
  }

  if (env.BRANCH_NAME == 'master') {
    stage("Publish Docker images to ${dockerRegistryUri}") {
      for (imageName in dockerImageNames) {
        println "------------------- Image name: ${imageName} -------------------"
        docker.image(imageName).inside {
          sh "cat /etc/*release"
        }
        docker.withRegistry(dockerRegistryUri, 'reynn-docker-repo-creds') {
          docker.image(imageName).push()
        }
      }
    }
  }

  currentBuild.result = 'SUCCESS'
  String slackMsg = "Successfully built ${JOB_NAME}\nAnsible Version: ${ansibleVersion}\nDuration: ${currentBuild.duration}"
  sendSlackMessage(slackMsg, '#git-notifications', 'mimikyu-sever')
}
