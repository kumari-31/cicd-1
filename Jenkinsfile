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
                        echo "$REGISTRY_CREDENTIALS_PSW" | docker login -u "$REGISTRY_CREDENTIALS_USR" --password-stdin
                        docker push kumari3123/cicd-1:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Checkout K8S manifest SCM(cicd)'){
            steps {
                git credentialsId: '7d53d6c5-61e7-4efc-9c05-34a4e3d9794f', 
                    url: 'https://github.com/kumari-31/cicd.git',
                    branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo(cicd)'){
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: '7d53d6c5-61e7-4efc-9c05-34a4e3d9794f', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                            git config user.email "skumari@cdac.in"
                            git config user.name "kumari-31"
                            cat yamlfiles/deploy.yaml
                            sed -i "s/PLACEHOLDER/${BUILD_NUMBER}/g" yamlfiles/deploy.yaml
                            cat yamlfiles/deploy.yaml
                            git add yamlfiles/deploy.yaml
                            git commit -m 'Updated the deploy yaml | Pipeline'
                            git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/kumari-31/cicd.git
                            git push origin HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
