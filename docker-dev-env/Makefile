# Docker Development Environment Makefile
# Usage: make [target]

.PHONY: help start stop restart build rebuild status logs shell create-project list-projects cleanup

# Default target
.DEFAULT_GOAL := help

# Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Help target
help: ## Show this help message
	@echo "$(BLUE)Docker Development Environment$(NC)"
	@echo ""
	@echo "$(YELLOW)Available targets:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Service management
start: ## Start all services
	@echo "$(BLUE)[INFO]$(NC) Starting Docker development environment..."
	@docker-compose up -d
	@echo "$(GREEN)[SUCCESS]$(NC) All services started successfully!"
	@make status

stop: ## Stop all services
	@echo "$(BLUE)[INFO]$(NC) Stopping Docker development environment..."
	@docker-compose down
	@echo "$(GREEN)[SUCCESS]$(NC) All services stopped successfully!"

restart: ## Restart all services
	@echo "$(BLUE)[INFO]$(NC) Restarting Docker development environment..."
	@make stop
	@make start

build: ## Build all images
	@echo "$(BLUE)[INFO]$(NC) Building Docker images..."
	@docker-compose build
	@echo "$(GREEN)[SUCCESS]$(NC) All images built successfully!"

rebuild: ## Rebuild all images (no cache)
	@echo "$(BLUE)[INFO]$(NC) Rebuilding Docker images (no cache)..."
	@docker-compose build --no-cache
	@echo "$(GREEN)[SUCCESS]$(NC) All images rebuilt successfully!"

status: ## Show services status
	@echo "$(BLUE)[INFO]$(NC) Services status:"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)[INFO]$(NC) Access URLs:"
	@echo "  Web Server: http://localhost"
	@echo "  Adminer: http://localhost:8080"
	@echo "  phpMyAdmin: http://localhost:8081"

# Logs and debugging
logs: ## Show logs for all services
	@docker-compose logs -f

logs-nginx: ## Show nginx logs
	@docker-compose logs -f nginx

logs-php74: ## Show PHP 7.4 logs
	@docker-compose logs -f php74

logs-php82: ## Show PHP 8.2 logs
	@docker-compose logs -f php82

logs-php84: ## Show PHP 8.4 logs
	@docker-compose logs -f php84

logs-mysql: ## Show MySQL logs
	@docker-compose logs -f mysql

logs-postgresql: ## Show PostgreSQL logs
	@docker-compose logs -f postgresql

# Shell access
shell: ## Open shell in PHP 8.4 container
	@docker-compose exec php84 /bin/sh

shell-php74: ## Open shell in PHP 7.4 container
	@docker-compose exec php74 /bin/sh

shell-php82: ## Open shell in PHP 8.2 container
	@docker-compose exec php82 /bin/sh

shell-php84: ## Open shell in PHP 8.4 container
	@docker-compose exec php84 /bin/sh

shell-mysql: ## Open MySQL shell
	@docker-compose exec mysql mysql -u root -p

shell-postgresql: ## Open PostgreSQL shell
	@docker-compose exec postgresql psql -U dev_user -d dev_db

# Project management
create-project: ## Create new project (usage: make create-project name=myproject php=php84 dir=public)
	@if [ -z "$(name)" ]; then \
		echo "$(RED)[ERROR]$(NC) Project name is required. Usage: make create-project name=myproject"; \
		exit 1; \
	fi
	@./bin/dev.sh create-project $(name) $(or $(php),php84) $(or $(dir),public)

list-projects: ## List all projects
	@echo "$(BLUE)[INFO]$(NC) Available projects:"
	@if [ -d "www" ]; then \
		for project in www/*; do \
			if [ -d "$$project" ]; then \
				echo "  - $$(basename $$project)"; \
			fi; \
		done; \
	else \
		echo "$(YELLOW)[WARNING]$(NC) No projects found in www/"; \
	fi

# Maintenance
cleanup: ## Remove unused containers and images
	@echo "$(BLUE)[INFO]$(NC) Cleaning up unused containers and images..."
	@docker system prune -f
	@echo "$(GREEN)[SUCCESS]$(NC) Cleanup completed!"

cleanup-all: ## Remove all containers, images, and volumes (DANGEROUS)
	@echo "$(RED)[WARNING]$(NC) This will remove ALL Docker containers, images, and volumes!"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ]
	@docker-compose down -v
	@docker system prune -a -f --volumes
	@echo "$(GREEN)[SUCCESS]$(NC) Complete cleanup finished!"

# Database operations
db-backup-mysql: ## Backup MySQL database (usage: make db-backup-mysql db=database_name)
	@if [ -z "$(db)" ]; then \
		echo "$(RED)[ERROR]$(NC) Database name is required. Usage: make db-backup-mysql db=database_name"; \
		exit 1; \
	fi
	@docker-compose exec mysql mysqldump -u root -p$(MYSQL_ROOT_PASSWORD) $(db) > backup_$(db)_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)[SUCCESS]$(NC) MySQL database $(db) backed up successfully!"

db-backup-postgresql: ## Backup PostgreSQL database (usage: make db-backup-postgresql db=database_name)
	@if [ -z "$(db)" ]; then \
		echo "$(RED)[ERROR]$(NC) Database name is required. Usage: make db-backup-postgresql db=database_name"; \
		exit 1; \
	fi
	@docker-compose exec postgresql pg_dump -U dev_user $(db) > backup_$(db)_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)[SUCCESS]$(NC) PostgreSQL database $(db) backed up successfully!"

# Development helpers
composer: ## Run composer command (usage: make composer cmd="install")
	@if [ -z "$(cmd)" ]; then \
		echo "$(RED)[ERROR]$(NC) Composer command is required. Usage: make composer cmd=\"install\""; \
		exit 1; \
	fi
	@docker-compose exec php84 composer $(cmd)

npm: ## Run npm command (usage: make npm cmd="install")
	@if [ -z "$(cmd)" ]; then \
		echo "$(RED)[ERROR]$(NC) NPM command is required. Usage: make npm cmd=\"install\""; \
		exit 1; \
	fi
	@docker-compose exec php84 npm $(cmd)

artisan: ## Run Laravel artisan command (usage: make artisan cmd="migrate")
	@if [ -z "$(cmd)" ]; then \
		echo "$(RED)[ERROR]$(NC) Artisan command is required. Usage: make artisan cmd=\"migrate\""; \
		exit 1; \
	fi
	@docker-compose exec php84 php artisan $(cmd)

# Quick setup
setup: ## Quick setup for new installation
	@echo "$(BLUE)[INFO]$(NC) Setting up Docker development environment..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(GREEN)[SUCCESS]$(NC) Environment file created from template"; \
	fi
	@chmod +x bin/dev.sh bin/generate-vhost.sh
	@echo "$(GREEN)[SUCCESS]$(NC) Scripts made executable"
	@make build
	@make start
	@echo "$(GREEN)[SUCCESS]$(NC) Docker development environment is ready!"
	@echo ""
	@echo "$(YELLOW)Next steps:$(NC)"
	@echo "1. Create your first project: make create-project name=myproject"
	@echo "2. Add to hosts file: 127.0.0.1 myproject.local"
	@echo "3. Access your project: http://myproject.local"

# Update
update: ## Update all images and rebuild
	@echo "$(BLUE)[INFO]$(NC) Updating Docker development environment..."
	@docker-compose pull
	@make rebuild
	@echo "$(GREEN)[SUCCESS]$(NC) Environment updated successfully!"
