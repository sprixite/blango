#!/usr/bin/env bash
# Deploy application.
# `````
# ./docker/scripts/deploy-uat.sh
# `````


# Copy sample env if does not exist
echo "Setting Up..."
[ ! -f .env ] && cp env.sample .env

[ ! -f ./docker/env.db ] && cp env.db.sample ./docker/env.db

# Run App
echo "Building and Running App..."
if [[ $(arch) = 'aarm64' ]]; then
  # We will force the docker to install Intel images. Then Apple M1 will use Rosetta to translate
  # Intel instructions to arm instructions.
  docker-compose -f docker-compose.staging.yml build --build-arg platform=linux/amd64
else
  docker-compose -f docker-compose.staging.yml build
fi
docker-compose -f docker-compose.staging.yml up -d

# Migrate
echo "Migrating..."
./docker/scripts/ssh.sh ./manage.py migrate

# Statics
echo "Collecting Statics..."
./docker/scripts/ssh.sh ./manage.py collectstatic --no-input
