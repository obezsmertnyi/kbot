pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Pick ARCH')
    }
    environment {
        REPO = "https://github.com/obezsmertnyi/kbot.git"
        BRANCH = 'main'
    }
    stages {
        stage("clone") {
            steps {
                echo 'Clone repo'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }
        stage("test") {
            steps {
                sh "make --version"
                echo 'Testing ... '
                sh 'make test'
            }
        }
        stage("build") {
            steps {
                echo 'Build image for platform ${params.OS} on ${params.ARCH}'
                sh 'make ${params.OS}'
            }
        }
        stage("image") {
            steps {
                script {
                    echo 'Build image for platform ${params.OS} on ${params.ARCH}'
                    sh 'make image'
                }
            }
        }
        stage("push") {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        sh 'make push'
                    }
                }
            }
        }
    }
}