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
                dir(WORKSPACE) {
                echo ">> Running terraform init with reconfigure"
                sh 'terraform init -reconfigure'
            }
        }
    }
        stage('Terraform Plan') {
            steps {
                dir(WORKSPACE) {
                    sh "terraform plan -var='resource_type=${params.RESOURCE_TYPE}' -var-file=terraform.tfvars"
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir(WORKSPACE) {
                    sh "terraform apply -var='resource_type=${params.RESOURCE_TYPE}' -var-file=terraform.tfvars -auto-approve"
                }
            }
        }
    }
}
