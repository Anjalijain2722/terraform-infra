pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS-ACCESS-KEYS')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-SECRET-KEYS')
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

