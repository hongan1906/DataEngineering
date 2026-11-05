-include .env
export

.PHONY: data up airflow down clean

data:        ## download all course datasets into ./data
	bash scripts/download_data.sh

up:          ## start MySQL, MongoDB and PostgreSQL
	docker compose up -d mysql mongo postgres

airflow:     ## start Airflow standalone on http://localhost:8080
	docker compose --profile airflow up -d airflow

down:
	docker compose --profile airflow down

clean:       ## stop everything and delete database volumes
	docker compose --profile airflow down -v
