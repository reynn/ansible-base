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
if (!params.ansibleVersion) {
  error('Unable to build image without providing the Ansible Version')
}
nodeDocker {
  stage('Checkout from GitHub') {
    checkout scm
  }

  stage('Build Images') {
    for (distro in ['alpine', 'ubuntu']) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      String imageName = "reynn/ansible:${params.ansibleVersion}-${distro}"
      if (dockerfileExists) {
        dockerImageNames.add(imageName)
        withEnv(["ANSIBLE_VERSION=${params.ansibleVersion}"]) {
          def image = docker.build(imageName, "-f Dockerfile-${distro} .")
        }
      }
    }
  }

  if (env.BRANCH_NAME == 'master' || forcePush) {
    stage("Publish Docker images") {
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
