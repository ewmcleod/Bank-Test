pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
		sh 'make clean'
		sh 'make'
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
