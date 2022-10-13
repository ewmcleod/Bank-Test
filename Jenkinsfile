def workspace
node {
    workspace = env.WORKSPACE
}
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
		sh 'make clean'
		sh 'cov-build --dir idir make'
		sh 'cov-analyze --dir idir
		sh 'cov-commit-defects --dir idir --host ${COVERITY_HOST} --stream ${COV_STREAM}'
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
