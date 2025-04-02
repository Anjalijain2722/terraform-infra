pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS-ACCESS-KEYS')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-SECRET-KEYS')
        TF_WORKDIR = "${WORKSPACE}"
    }
    parameters {
        choice(name: 'RESOURCE_TYPE', choices: ['redis', 'vpc'], description: 'Select the resource to deploy')
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
        stage('Terraform Plan') {
            steps {
                dir(WORKSPACE) {
                    script {
                        if (params.RESOURCE_TYPE == 'redis') {
                            sh 'terraform plan -var="resource=redis"'
                        } else if (params.RESOURCE_TYPE == 'vpc') {
                            sh 'terraform plan -var="resource=vpc"'
                        }
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir(WORKSPACE) {
                    script {
                        if (params.RESOURCE_TYPE == 'redis') {
                            sh 'terraform apply -var="resource=redis" -auto-approve'
                        } else if (params.RESOURCE_TYPE == 'vpc') {
                            sh 'terraform apply -var="resource=vpc" -auto-approve'
                        }
                    }
                }
            }
        }
    }
}
