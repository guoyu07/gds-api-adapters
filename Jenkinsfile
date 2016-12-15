#!/usr/bin/env groovy

REPOSITORY = 'gds-api-adapters'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout gds-api-adapters") {
      checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'gds-api-adapters']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github-token-govuk-ci-username', name: 'gds-api-adapters', url: 'https://github.com/alphagov/gds-api-adapters.git']]]
    }

    def pact_branch = (env.BRANCH_NAME == 'master' ? 'master' : "branch-${env.BRANCH_NAME}")

    stage("Build") {
      dir("gds-api-adapters") {
      withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'pact-broker-ci-dev',
        usernameVariable: 'PACT_BROKER_USERNAME', passwordVariable: 'PACT_BROKER_PASSWORD']]) {
        withEnv(["PACT_TARGET_BRANCH=${pact_branch}"]) {
          sshagent(['govuk-ci-ssh-key']) {
            sh "${WORKSPACE}/jenkins.sh"
          }
        }
      }

      publishHTML(target: [
        allowMissing: false,
        alwaysLinkToLastBuild: false,
        keepAll: true,
        reportDir: 'coverage/rcov',
        reportFiles: 'index.html',
        reportName: 'RCov Report'
      ])
      }
    }

    stage("Checkout publishing-api") {
      checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'publishing-api']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github-token-govuk-ci-username', name: 'publishing-api', url: 'https://github.com/alphagov/publishing-api.git']]]
    }

    stage("Run publishing-api pact") {
      dir("publishing-api") {
        withEnv(["JOB_NAME=publishing-api"]) { // TODO: This environment is a hack
          govuk.bundleApp()
        }
        govuk.runRakeTask("pact:verify:branch[${pact_branch}]")
      }
    }

    if (env.BRANCH_NAME == 'master') {
      dir("gds-api-adapters") {
      stage("Push release tag") {
        echo 'Pushing tag'
        govuk.pushTag(REPOSITORY, env.BRANCH_NAME, 'release_' + env.BUILD_NUMBER)
      }

      stage("Publish gem") {
        echo 'Publishing gem'
        bundleApp()
        sh("bundle exec rake publish_gem --trace")
      }
      }
    }
  } catch (e) {
    currentBuild.result = "FAILED"
    /*
    step([$class: 'Mailer',
          notifyEveryUnstableBuild: true,
          recipients: 'govuk-ci-notifications@digital.cabinet-office.gov.uk',
          sendToIndividuals: true])
    */
    throw e
  }
}
