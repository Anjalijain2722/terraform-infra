pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEYS')     // Store in Jenkins credentials
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEYS')     // Store in Jenkins credentials
    }

   stage('Terraform Init') {
    steps {
        sh 'terraform init -reconfigure'
    }
}


        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var-file="terraform.tfvars"'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Proceed with apply?"
                sh 'terraform apply -auto-approve -var-file="terraform.tfvars"'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
    }
}
