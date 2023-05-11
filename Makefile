.PHONY: up down logs status start isort black code-quality help
.DEFAULT_GOAL := help
run-docker-compose = docker compose -f docker-compose.yml
run-uvicorn = uvicorn

up: # Start containers and tail logs
	$(run-docker-compose) up -d

down: # Stop all containers
	$(run-docker-compose) down --remove-orphans

logs: # Tail container logs
	$(run-docker-compose) logs -f mariadb

status: # Show status of all containers
	$(run-docker-compose) ps

start: # Start server
	$(run-uvicorn) controlpi.app:app --reload

isort: # Run isort
	isort .

code-quality: isort black # Run code quality tools

black : # Run black
	black .

help: # make help
	@awk 'BEGIN {FS = ":.*#"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?#/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
