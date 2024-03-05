.SILENT: infra start
.PHONY: infra start update-doc

infra:
	docker network create rover_app || true
	cp docker/.env-example docker/.env
	cp .env-example .env
	cd docker && docker-compose up -d --build
	echo "Finish ✅"

update-doc:
	docker exec -u dev rover_app bash -c "RACK_ENV=test rake rswag:specs:swaggerize"

start:
	make infra

