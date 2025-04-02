pipeline {
    agent any
    environment {
        TF_WORKDIR = "${WORKSPACE}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Anjalijain2722/terraform-infra.git'
            }
        }
        stage('Terraform Init') {
            steps {
                dir(WORKSPACE) {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir(WORKSPACE) {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}

