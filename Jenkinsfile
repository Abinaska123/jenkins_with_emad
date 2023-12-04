pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID = "591481069844"
        AWS_DEFAULT_REGION = "eu-north-1"
        IMAGE_REPO_NAME = "prod-laravel-api-base-image"
        IMAGE_TAG = "latest"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
   
    stages {
        stage('Logging into AWS ECR') {
            steps {
                script {
                    // Log in to AWS ECR
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}"
                }
            }
        }
        
        // Optional: Git clone stage if needed
        // stage('Cloning Git') {
        //     steps {
        //         checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/sd031/aws_codebuild_codedeploy_nodeJs_demo.git']]])     
        //     }
        // }

        // Building Docker images
        stage('Building image') {
            steps {
                script {
                    // Build Docker image
                    //cp env.prod .env
                    sh "docker build -t prod-laravel-api-base-image ."
                }
            }
        }
   
        // Uploading Docker images into AWS ECR
        stage('Pushing to ECR') {
            steps {
                script {
                    // Tag the Docker image
                    //docker.image("${IMAGE_REPO_NAME}:${IMAGE_TAG}").tag("${REPOSITORY_URI}:${IMAGE_TAG}")
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
                    


                    // Push the Docker image to AWS ECR
                    //docker.withRegistry("${REPOSITORY_URI}", "${AWS_DEFAULT_REGION}") 
                    //docker.withRegistry("${REPOSITORY_URI}", eu-north-1) 
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                    //{
                        //docker.image("${IMAGE_REPO_NAME}:${IMAGE_TAG}").push()
                        sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"

                    //}
                }
            }
        }
    }
}
