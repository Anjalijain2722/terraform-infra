pipeline {
    agent any

    parameters {
        choice(
            name: 'RESOURCE_TYPE',
            choices: ['vpc', 'ElastiCache-Redis'],
            description: 'Select the resource to provision'
        )
    }

    environment {
        AWS_REGION = "ap-south-1"
        BUCKET_NAME = "redis-testing-bucket-new"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    echo "Initializing Terraform..."
                    terraform init -backend-config="bucket=${BUCKET_NAME}" -backend-config="region=${AWS_REGION}"
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                    echo "Validating Terraform code..."
                    terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    echo "Planning with selected resource: ${RESOURCE_TYPE}"
                    terraform plan -var="resource_type=${RESOURCE_TYPE}"
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    echo "Applying Terraform config..."
                    terraform apply -auto-approve -var="resource_type=${RESOURCE_TYPE}"
                '''
            }
        }
    }

    post {
        failure {
            echo "Terraform execution failed. Please check logs."
        }
        success {
            echo "Terraform execution succeeded!"
        }
    }
}
