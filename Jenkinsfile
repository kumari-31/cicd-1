pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('docker-credentials')
    }
    
    stages {
        
        stage('Checkout'){
           steps {
                git credentialsId: '2a4cd6cb-342a-4322-a9d9-b3b4042a0048',
                url: 'https://github.com/kumari-31/cicd-1.git',
                branch: 'main'
           }
        }
        
        stage('Build Docker'){
            steps{
                script{
                    sh '''
                        echo 'Buid Docker Image'
                        docker build -t kumari3123/cicd-1:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
            steps{
                script{
                    sh '''
                        echo 'Push to Repo'
                        docker login -u "$REGISTRY_CREDENTIALS_USR" -p "$REGISTRY_CREDENTIALS_PSW"
                        docker push kumari3123/cicd-1:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Checkout K8S manifest SCM(cicd-2)'){
            steps {
                git credentialsId: '2a4cd6cb-342a-4322-a9d9-b3b4042a0048', 
                    url: 'https://github.com/kumari-31/cicd-2.git',
                    branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo(cicd-2)'){
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: '2a4cd6cb-342a-4322-a9d9-b3b4042a0048', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                            cat deploy.yaml
                            sed -i '' "s/32/${BUILD_NUMBER}/g" deploy.yaml
                            cat deploy.yaml
                            git add deploy.yaml
                            git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                            git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/kumari-31/cicd-2.git
                            git push https://github.com/kumari-31/cicd-2.git HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
