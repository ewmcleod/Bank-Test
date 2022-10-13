def workspace
node {
    workspace = env.WORKSPACE
}
withCoverityEnvironment() {
	coverityInstanceUrl = $COVERITY_HOST
  // execute any coverity commands with either `sh` or `bat` script step
  //  (all Coverity Tools in /bin available on PATH)
  // By default, Coverity Connect Instance information will be avaible in following environment variables
  //
  // HOST -> COVERITY_HOST
  // PORT -> COVERITY_PORT
  // USER -> COV_USER
  // PASSWORD -> COVERITY_PASSPHRASE
  //
  // Users can customize all the above default environment variables
}
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
		sh 'cov-build --dir ${WORKSPACE}/idir  make'
		sh 'cov-analyze --dir ${WORKSPACE}/idir'
		sh 'cov-commit-defects --dir ${WORKSPACE}/idir --host ${COVERITY_HOST} --stream ${COV_STREAM}'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing not implemented'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying not implemented'
            }
        }
    }
}
