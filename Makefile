
# Docker image settings
DOCKER_IMAGE_NAME = khasty720/traccar
DOCKER_TAG = latest
DOCKER_FULL_TAG = $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

# Build Docker image from Dockerfile
docker-build:
	@echo "Building Docker image $(DOCKER_FULL_TAG) from Dockerfile..."
	docker build -t $(DOCKER_FULL_TAG) -f Dockerfile .

# Run the Docker container
docker-run:
	@echo "Running Docker container $(DOCKER_FULL_TAG)..."
	docker run \
		--name traccar \
		--hostname traccar \
		--rm \
		--env-file ./.env \
		-p 5432:5432 \
		-p 80:8082 \
		-p 5200-5350:5000-5150 \
		-p 5200-5350:5000-5150/udp \
		-v ./logs:/opt/traccar/logs:rw \
		-v ./conf/traccar.xml:/opt/traccar/conf/traccar.xml:ro \
		$(DOCKER_FULL_TAG)

# Build and push Docker image
docker-push: docker-build
	docker push $(DOCKER_FULL_TAG)

# Start using docker-compose
docker-compose-up:
	docker-compose up

# Stop docker-compose services
docker-compose-down:
	docker-compose down

.PHONY: docker-build docker-run docker-push docker-compose-up docker-compose-down

# Build the Java application
java-debug:
	@echo "Running Java application in debug mode..."
	./tools/run-debug-server.sh