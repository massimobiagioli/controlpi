.PHONY: up down logs status start isort black bandit flake8 safety code-quality pre-commit-install help
.DEFAULT_GOAL := help
run-docker-compose = docker compose -f docker-compose.yml
run-uvicorn = uvicorn
run-poetry = poetry
run-bandit = bandit
run-pre-commit = pre-commit

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
	$(run-poetry) run isort .

black : # Run black
	$(run-poetry) run black .

bandit: # Run bandit
	$(run-bandit) --ini .bandit

flake8: # Run flake8
	$(run-poetry) run flake8 ./controlpi ./tests

safety: # Run safety
	$(run-poetry) run safety check --bare --ignore=42194

code-quality: isort black bandit flake8 safety # Run code quality tools

pre-commit-install: # Install pre-commit hooks
	$(run-pre-commit) install

help: # make help
	@awk 'BEGIN {FS = ":.*#"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?#/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
