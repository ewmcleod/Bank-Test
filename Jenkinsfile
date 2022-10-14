def workspace
node {
    workspace = env.WORKSPACE
}
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
		withCoverityEnvironment(coverityInstanceUrl: 'http://us1a-eng-emcleod.nprd.sig.synopsys.com:8080', projectName: 'bankapp', streamName: 'bankapp', 
viewName: ''){
			sh 'cov-build --dir ${WORKSPACE}/idir  make'
			sh 'cov-analyze --dir ${WORKSPACE}/idir'
			sh 'cov-commit-defects --dir ${WORKSPACE}/idir --url ${COVERITY_HOST} --stream ${COV_STREAM}'
		}
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
