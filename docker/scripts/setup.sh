#!/usr/bin/env bash

if [[ $(arch) = 'aarm64' ]]; then
	# We will force the docker to install Intel images. Then Apple M1 will use Rosetta to translate
	# Intel instructions to arm instructions.
	docker-compose build --build-arg platform=linux/amd64
else
	docker-compose build
fi

[ ! -f .env ] && cp env.sample .env

[ ! -f ./docker/env.db ] && cp env.db.sample ./docker/env.db
