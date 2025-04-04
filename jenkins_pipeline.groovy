pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS-ACCESS-KEYS')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-SECRET-KEYS')
        TF_WORKDIR            = "${WORKSPACE}"
    }

    parameters {
        choice(name: 'RESOURCE_TYPE', choices: ['vpc', 'redis'], description: 'Select the resource to deploy')
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Anjalijain2722/terraform-infra.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKDIR}") {
                    echo ">> Running terraform init with reconfigure"
                    sh '''
                        terraform init -reconfigure \
                          -backend-config="bucket=redis-testing-bucket" \
                          -backend-config="key=global/terraform.tfstate" \
                          -backend-config="region=ap-south-1"
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_WORKDIR}") {
                    echo ">> Planning Terraform changes for resource: ${params.RESOURCE_TYPE}"
                    sh "terraform plan -var='resource=${params.RESOURCE_TYPE}' -var-file=terraform.tfvars"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_WORKDIR}") {
                    echo ">> Applying Terraform changes for resource: ${params.RESOURCE_TYPE}"
                    sh "terraform apply -var='resource=${params.RESOURCE_TYPE}' -var-file=terraform.tfvars -auto-approve"
                }
            }
        }
    }

    post {
        success {
            echo "Terraform ${params.RESOURCE_TYPE} deployed successfully!"
        }
        failure {
            echo "Terraform ${params.RESOURCE_TYPE} deployment failed."
        }
    }
}
