# Makefile

# Variables
DOCKER_COMPOSE_FILE=docker-compose.yaml
DOCKER_REPO_BACKEND=thusithanc/gke-apptest-backend
DOCKER_REPO_UI=thusithanc/gke-apptest-ui

# Targets
.PHONY: build push

build: build_backend build_ui
	echo "Build completed"

build_backend:
	docker compose -f $(DOCKER_COMPOSE_FILE) build backend

build_ui:
	docker compose -f $(DOCKER_COMPOSE_FILE) build ui

push: build
	docker compose -f $(DOCKER_COMPOSE_FILE) push

gke-login:
	gcloud auth activate-service-account --key-file="/home/${USER}/gke-deployer-key.json"
