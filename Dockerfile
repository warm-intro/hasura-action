FROM frolvlad/alpine-glibc:alpine-3.15_glibc-2.33

LABEL repository="https://github.com/warm-intro/hasura-action"
LABEL homepage="https://github.com/warm-intro/hasura-action"
LABEL maintainer="Warmly Dev <dev@warmly.ai>"

LABEL com.github.actions.name="GitHub Action for Hasura"
LABEL com.github.actions.description="Wraps the Hasura CLI to run migrate and metadata."
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="gray-dark"

RUN apk add --no-cache curl bash libstdc++ jq
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
