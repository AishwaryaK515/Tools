🚀 Day 4: Jenkins + Docker Integration & Containerized CI/CD
 📌 Goal: Learn how to integrate Jenkins with Docker, build Docker images, and push them to Docker Hub for deployment.









🔹 Step 1: Install & Configure Docker on Jenkins Server
Since Jenkins will manage Docker containers, Docker must be installed on the Jenkins server.

1️⃣ Install Docker
-  sudo yum install docker -y
2️⃣ Enable & Start Docker
-  sudo systemctl enable docker
-  sudo systemctl start docker
3️⃣ Verify Docker Installation
-  docker --version
-  sudo docker run hello-world
4️⃣ Allow Jenkins to Run Docker Commands
By default, Jenkins runs as the jenkins user, which doesn’t have permission to manage Docker.
Add Jenkins to the Docker group:
-  sudo usermod -aG docker jenkins
-  sudo systemctl restart jenkins
Verify if Jenkins can access Docker:
-  sudo su - jenkins -s /bin/bash
-  docker ps
-  exit
✅ If docker ps works without error, Jenkins can manage Docker containers.



🔹 Step 2: Install Docker Plugin in Jenkins
1️⃣ Go to Jenkins Dashboard → Manage Jenkins → Manage Plugins
2️⃣ Search for "Docker Pipeline" Plugin
3️⃣ Install it & Restart Jenkins


🔹 Step 3: Update Jenkinsfile to Include Docker Build & Push
Now, we modify our Jenkinsfile to:

Build a Docker Image
Push it to Docker Hub
1️⃣ Update Jenkinsfile
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubuser/myapp:latest"
        DOCKER_CREDENTIALS = credentials('docker-hub-credentials')  // Stored in Jenkins credentials
    }

    tools {
        maven 'maven'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/AishwaryaK515/tools.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package'
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                sh '''
                echo $DOCKER_CREDENTIALS | docker login -u yourdockerhubuser --password-stdin
                docker push $DOCKER_IMAGE
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying the application...'
            }
        }
    }

    post {
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Deployment Failed!"
        }
    }
}


✅ This pipeline will now build, test, containerize, and push your app to Docker Hub.

🔹 Step 4: Add Docker Hub Credentials to Jenkins
Jenkins needs to authenticate to Docker Hub before pushing images.

1️⃣ Go to Jenkins Dashboard → Manage Jenkins → Manage Credentials
2️⃣ Select Global Credentials (unrestricted)
3️⃣ Click Add Credentials
4️⃣ Select Username & Password

Username: your Docker Hub username
Password: your Docker Hub password
ID: docker-hub-credentials (must match Jenkinsfile)
5️⃣ Click OK

🔹 Step 5: Run the Pipeline in Jenkins
1️⃣ Go to Jenkins Dashboard → Your Pipeline Job
2️⃣ Click Build Now
3️⃣ Check the Console Output:

✅ Clone the repo
✅ Build with Maven
✅ Build Docker Image
✅ Push Image to Docker Hub
✅ Check Your Image on Docker Hub:
docker login
docker pull yourdockerhubuser/myapp:latest
docker run -d -p 8080:80 yourdockerhubuser/myapp:latest
🌍 Now your app is running inside a Docker container!
















