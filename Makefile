
# Docker image settings
DOCKER_IMAGE_NAME = khasty/traccar
DOCKER_TAG = latest
DOCKER_FULL_TAG = $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

# Build Docker image from Dockerfile.alpine
docker-build:
	@echo "Building Docker image $(DOCKER_FULL_TAG) from Dockerfile.alpine..."
	docker build -t $(DOCKER_FULL_TAG) -f Dockerfile.alpine .

# Run the Docker container
docker-run:
	docker run -p 80:8082 -p 5200-5350:5000-5150 -p 5200-5350:5000-5150/udp $(DOCKER_FULL_TAG)

# Build and push Docker image
docker-push: docker-build
	docker push $(DOCKER_FULL_TAG)

# Start using docker-compose
docker-compose-up:
	docker-compose up -d

# Stop docker-compose services
docker-compose-down:
	docker-compose down

.PHONY: docker-build docker-run docker-push docker-compose-up docker-compose-down
