pipeline {
    agent any
    environment{
        FULL_IMAGE = "430950558682.dkr.ecr.ap-southeast-1.amazonaws.com/devops-final-assignment-frontend:latest"
        TASK_DEFINITION =""
        NEW_TASK_DEFINITION=""
        NEW_TASK_INFO=""
        NEW_REVISION=""
        TASK_FAMILY="frontend-task-definition"
        CLUSTER_NAME="final-assignment-ecs-cluster"
        SERVICE_NAME="final-assignment-fe"
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t final-assignment-frontend:latest .'
            }
        }
        stage('Upload image to ECR') {
            steps {
                sh 'aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 430950558682.dkr.ecr.ap-southeast-1.amazonaws.com'

                sh 'docker tag final-assignment-frontend:latest ${FULL_IMAGE}'
                
                sh 'docker push ${FULL_IMAGE}'
            }
        }
        
        stage('Update task definition and force deploy ecs service') {
            steps {
                sh '''
                    TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition ${TASK_FAMILY} --region "ap-southeast-1")
                    NEW_TASK_DEFINITION=$(echo $TASK_DEFINITION | jq --arg IMAGE "${FULL_IMAGE}" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) |  del(.registeredAt)  | del(.registeredBy)')
                    NEW_TASK_INFO=$(aws ecs register-task-definition --region "ap-southeast-1" --cli-input-json "$NEW_TASK_DEFINITION")
                    NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')
                    aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${NEW_REVISION} --force-new-deployment
                '''
 
            }
        }
    }
}
