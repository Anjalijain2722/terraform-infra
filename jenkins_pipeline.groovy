pipeline {
    agent any
    parameters {
        string(name: 'RESOURCE_TYPE', defaultValue: 'redis', description: 'Resource to create (redis, ec2, s3, etc.)')
        string(name: 'REDIS_CLUSTER_ID', defaultValue: 'redis-cluster', description: 'Redis Cluster ID')
        string(name: 'REDIS_NODE_TYPE', defaultValue: 'cache.t2.micro', description: 'Redis Node Type')
        string(name: 'REDIS_NUM_NODES', defaultValue: '1', description: 'Number of Redis Nodes')
    }
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
                dir("${TF_WORKDIR}") {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir("${TF_WORKDIR}") {
                    script {
                        def command = "terraform apply -auto-approve "
                        if (params.RESOURCE_TYPE == 'redis') {
                            command += "-var 'redis_cluster_id=${params.REDIS_CLUSTER_ID}' "
                            command += "-var 'redis_node_type=${params.REDIS_NODE_TYPE}' "
                            command += "-var 'redis_num_nodes=${params.REDIS_NUM_NODES}'"
                        }
                        sh command
                    }
                }
            }
        }
    }
}
