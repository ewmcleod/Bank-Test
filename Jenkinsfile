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
