def workspace
node {
    workspace = env.WORKSPACE
}
pipeline {
    agent any
    
    environment {
        CONNECT = 'https://us1a-eng-emcleod.nprd.sig.synopsys.com:8443'
        PROJECT = 'bankapp'
        BLDCMD = 'make'
        CHECKERS = '--webapp-security --enable-callgraph-metrics'
        COVERITY_NO_LOG_ENVIRONMENT_VARIABLES = '1'
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
                        withCoverityEnvironment(coverityInstanceUrl: "$CONNECT", projectName: "$PROJECT", streamName: "$PROJECT-$GIT_BRANCH") {
                            sh '''
                                cov-build --dir idir $WORKSPACE $BLDCMD
                                cov-analyze --dir idir --ticker-mode none --strip-path $WORKSPACE $CHECKERS
                                cov-commit-defects --dir idir --ticker-mode none --url $COV_URL --stream $COV_STREAM \
                                    --description $BUILD_TAG --version $GIT_COMMIT
                            '''
                            script { // Coverity Quality Gate
                                count = coverityIssueCheck(viewName: 'OWASP Web Top 10', returnIssueCount: true)
                                if (count != 0) { unstable 'issues detected' }
                            }
                        }
                    }
                }
                stage('Coverity Incremental Scan') {
                    steps {
                        withCoverityEnvironment(coverityInstanceUrl: "$CONNECT", projectName: "$PROJECT", streamName: "$PROJECT-$CHANGE_TARGET") {
                            sh '''
                                export CHANGE_SET=$(git --no-pager diff origin/$CHANGE_TARGET --name-only)
                                [ -z "$CHANGE_SET" ] && exit 0
                                cov-run-desktop --dir idir --url $COV_URL --stream $COV_STREAM --build $BLDCMD
                                cov-run-desktop --dir idir --url $COV_URL --stream $COV_STREAM --present-in-reference false \
                                    --ignore-uncapturable-inputs true --text-output issues.txt $CHANGE_SET
                                if [ -s issues.txt ]; then cat issues.txt; touch issues_found; fi
                            '''
                        }
                        script { // Coverity Quality Gate
                            if (fileExists('issues_found')) { unstable 'issues detected' }
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