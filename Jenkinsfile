def workspace
node {
    workspace = env.WORKSPACE
}
pipeline {
    agent any
    
    environment {
        CONNECT = 'https://us1a-eng-emcleod.nprd.sig.synopsys.com:8443'
        PROJECT = 'bankapp'
        BLDCMD = 'make clean all'
        CHECKERS = '--webapp-security --enable-callgraph-metrics'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'make'
                }
        }
        stage('Test') {
            steps {
                echo 'Testing not implemented'
            }
        }
        stage('Security Testing') {
            parallel {
                stage('Coverity Full Scan') {
                    steps {
                        withCoverityEnvironment(coverityInstanceUrl: "$CONNECT", projectName: "$PROJECT", streamName: $PROJECT-"${GIT_BRANCH,fullName=false}", createMissingProjectsAndStreams: true) {
                            sh '''
                                cov-build --dir  ${WORKSPACE}/idir  $BLDCMD
                                cov-analyze --dir  ${WORKSPACE}/idir --strip-path $WORKSPACE $CHECKERS
                                cov-commit-defects --dir  ${WORKSPACE}/idir --auth-key-file $COV_AUTH_KEY_PATH --ticker-mode none --url $COV_URL --stream $COV_STREAM \
                                    --description $BUILD_TAG --version $GIT_COMMIT
                            '''
                            script { // Coverity Quality Gate
                                count = coverityIssueCheck(viewName: 'Newly detected Issues', returnIssueCount: true)
                                if (count != 0) { unstable 'issues detected' }
                            }
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying not implemented'
            }
        }
    }
}