pipeline {
    agent any

    triggers {
        pollSCM('H/2 * * * *')   // or use a GitHub webhook instead
    }

    environment {
        IMAGE     = 'sample-site'
        CONTAINER = 'sample-site'
        HOST_PORT = '8081'       // 8080 is usually taken by Jenkins
        SITE_REPO = 'https://github.com/jatin110105/sample-site.git'
    }

    stages {
        stage('Checkout Dockerfile') {
            steps {
                checkout scm
            }
        }

        stage('Checkout Site') {
            steps {
                dir('site') {
                    git branch: 'main', url: "${SITE_REPO}"
                }
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE:$BUILD_NUMBER -t $IMAGE:latest .'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f $CONTAINER || true
                    docker run -d --name $CONTAINER -p $HOST_PORT:80 $IMAGE:latest
                '''
            }
        }

        stage('Verify') {
            steps {
                sh 'sleep 3 && curl -f http://localhost:$HOST_PORT'
            }
        }
    }

    post {
        success { echo "Live at http://<server-ip>:${HOST_PORT}" }
        failure { echo 'Pipeline failed, check the stage logs' }
    }
}
