## Name: Aderinto Adedayo 
## Slack: @khen_theDev

# PROJECT: HNGi 13 Stage 2 - DevOps Task

This repository contains the solution for the HNGi 13 Stage 2 DevOps task, which involves setting up a blue-green deployment with chaos engineering to ensure zero downtime during deployments.

## Features
- Blue-Green Deployment: Two identical production environments (Blue and Green) to ensure zero downtime during deployments.
- Chaos Engineering: Simulates failures in the Blue environment to test the failover mechanism to the
    Green environment.

## Technologies Used
- AWS EC2: Hosting the application.
- Docker: Containerization of the application.
- Nginx: Web server to route traffic between Blue and Green environments.
- YAML: Configuration files for Docker Compose.

## Setup Instructions
1. Clone the repository:

   ```bash
   git clone https://github.com/iamDayoDev/hng13-stage2-devops.git
   ```

2. Navigate to the project directory:

   ```bash
   cd hng13-stage2-devops
   ```

3. Build and start the Docker containers:

    ```bash
    docker-compose up -d
    ```

4. Access the application:
   Open your web browser and navigate to `http://localhost:8080/` to see the application running.

## Testing
To test the blue-green deployment and chaos engineering setup, run the provided.

```bash
curl -i http://localhost:8080/version
```

```bash
curl -X POST http://localhost:8081/chaos/start?mode=error
```
Watch the application switch from Blue to Green environment upon failure simulation.

```bash
curl -i http://localhost:8080/version
```

```bash
curl -X POST http://localhost:8081/chaos/stop
```

## SERVER_IP = 13.52.255.187

Replace `localhost` with `SERVER_IP` to test on the deployed AWS EC2 instance.

```bash
http://SERVER_IP:8080/
http://SERVER_IP:8080/version
http://SERVER_IP:8081/chaos/start?mode=error
http://SERVER_IP:8081/chaos/stop
```