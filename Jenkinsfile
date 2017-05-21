#!/usr/bin/env groovy

// available to view at https://github.com/reynn/jenkins-pipeline
@Library("pipelineLibraries")_

// Variables

properties([
      [$class: 'DatadogJobProperty', tagFile: '', tagProperties: ''],
      parameters([
        string(defaultValue: '', description: 'Version of Ansible to install in image', name: 'ansibleVersion'),
        booleanParam(defaultValue: false, description: '', name: 'forcePush')
      ]),
      pipelineTriggers([])]
)

List dockerImageNames = []

nodeDocker {
  stage('Checkout from GitHub') {
    checkout scm
  }

  stage('Build Images') {
    for (distro in ['alpine', 'ubuntu']) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      String imageName = "reynn/ansible:${params.ansibleVersion}-${distro}"
      String buildArgs = " "
      if (dockerfileExists) {
        dockerImageNames.add(imageName)
        def image = docker.build(imageName, buildArgs)
      }
    }
  }

  if (env.BRANCH_NAME == 'master' || forcePush) {
    stage("Publish Docker images to ${dockerRegistryUri}") {
      for (imageName in dockerImageNames) {
        println "------------------- Image name: ${imageName} -------------------"
        docker.image(imageName).push()
      }
    }
  }

  currentBuild.result = 'SUCCESS'
  String slackMsg = "Successfully built ${JOB_NAME}\nAnsible Version: ${ansibleVersion}\nDuration: ${currentBuild.duration}"
  sendSlackMessage(slackMsg, '#git-notifications', 'mimikyu-sever')
}
