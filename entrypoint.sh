#!/bin/sh -l

set -e

if [ -z "$HASURA_ENDPOINT" ]; then
    echo "HASURA_ENDPOINT is required to run commands with the hasura cli"
    exit 126
fi

migrate_command="hasura migrate apply --all-databases --endpoint '$HASURA_ENDPOINT'"
metadata_command="hasura metadata apply --endpoint '$HASURA_ENDPOINT'"

if [ -n "$HASURA_ADMIN_SECRET" ]; then
    migrate_command="$migrate_command --admin-secret '$HASURA_ADMIN_SECRET'"
    metadata_command="$metadata_command --admin-secret '$HASURA_ADMIN_SECRET'"
fi

if [ -n "$HASURA_WORKDIR" ]; then
    cd $HASURA_WORKDIR
fi

# create mock config file if none found
if [ ! -f config.yaml ]; then
    touch config.yaml
fi

if [ -n "$HASURA_ENGINE_VERSION" ]; then
    hasura update-cli --version $HASURA_ENGINE_VERSION
else
  DETECTED_HASURA_ENGINE_VERSION=$(curl -s "$HASURA_ENDPOINT"/v1/version \
    | jq .version \
    | awk '{split($0,a,"-"); print a[1]}' \
    | awk '{split($0,a,"\""); print a[2]}')

  if [ -n "$DETECTED_HASURA_ENGINE_VERSION" ]; then
      hasura update-cli --version $DETECTED_HASURA_ENGINE_VERSION
  fi
fi

# secrets can be printed, they are protected by Github Actions
echo "Executing $migrate_command && $metadata_command from ${HASURA_WORKDIR:-./}"

sh -c "$migrate_command && $metadata_command"
