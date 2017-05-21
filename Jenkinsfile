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
    for (distro in ['alpine', 'ubuntu', 'centos', 'fedora25']) {
      def dockerfileExists = fileExists "Dockerfile-${distro}"
      String imageName = "reynn/ansible-${distro}:${params.ansibleVersion}"
      if (dockerfileExists) {
        dockerImageNames.add(imageName)
        def ansibleVersions = params.ansibleVersion.split(',')
        for(ver in ansibleVersions) {
          withEnv(["ANSIBLE_VERSION=${ver}"]) {
            def image = docker.build(imageName, "-f Dockerfile-${distro} .")
          }
        }
      }
    }
  }

  if (env.BRANCH_NAME == 'master' || forcePush) {
    stage("Publish Docker images") {
      docker.withRegistry('https://index.docker.io/v1/', '2ba024f8-eb65-4045-a1eb-a9997699cbee') {
        for (imageName in dockerImageNames) {
          println "------------------- Image name: ${imageName} -------------------"
          docker.image(imageName).push()
          docker.image(imageName).push( 'latest' )
        }
      }
    }
  }

  currentBuild.result = 'SUCCESS'
  String slackMsg = "Successfully built ${JOB_NAME}\nAnsible Version: ${ansibleVersion}\nDuration: ${currentBuild.duration}"
  sendSlackMessage(slackMsg, '#git-notifications', 'mimikyu-sever')
}
