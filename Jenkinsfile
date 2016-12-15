#!/usr/bin/env groovy

REPOSITORY = 'gds-api-adapters'

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'

  try {
    stage("Checkout") {
      checkout scm
    }

    stage("Build") {
      withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'pact-broker-ci-dev',
        usernameVariable: 'PACT_BROKER_USERNAME', passwordVariable: 'PACT_BROKER_PASSWORD']]) {
        def pact_branch = (env.BRANCH_NAME == 'master' ? 'master' : "branch-${env.BRANCH_NAME}")
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

    if (branch == 'master') {
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
