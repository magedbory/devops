pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    environment {
        // !!! REPLACE YOUR_USERNAME WITH YOUR ACTUAL WINDOWS USERNAME !!!
        DOCKER_BIN = '"C:\\Users\\Eng.Maged\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin"'
        DOCKER_EXE = '"C:\\Users\\Eng.Maged\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe"'
        
        IMAGE_NAME = 'devops-test'
        CONTAINER_NAME = 'web-test'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                // We add the bin folder to the execution PATH for this block and call docker.exe
                bat """
                    set PATH=%DOCKER_BIN%;%PATH%
                    %DOCKER_EXE% build -t "%IMAGE_NAME%:%BUILD_NUMBER%" .
                """
            }
        }

        stage('Deploy') {
            steps {
                // Windows batch doesn't use "\" for multi-line commands. 
                // We group them inside a proper batch block.
                bat """
                    set PATH=%DOCKER_BIN%;%PATH%
                    %DOCKER_EXE% rm -f "%CONTAINER_NAME%" || echo "No existing container to remove."
                    %DOCKER_EXE% run -d --name "%CONTAINER_NAME%" --restart unless-stopped -p 8060:80 "%IMAGE_NAME%:%BUILD_NUMBER%"
                """
            }
        }

        stage('Verify') {
            steps {
                // Windows batch uses 'timeout' instead of 'sleep', and 'curl' commands look cleaner without linux-style slashes.
                bat '''
                    timeout /t 2 /nobreak
                    curl --fail --silent --show-error http://127.0.0.1:8080 
                    echo "Application is responding on port 80."
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment completed successfully."
        }
        failure {
            echo "Pipeline failed. Review the stage logs above."
        }
    }
}
