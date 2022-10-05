ARG QUORUM_VERSION=latest

FROM quorumengineering/quorum:${QUORUM_VERSION}

RUN apk add --no-cache curl jq

COPY docker-entrypoint.sh /usr/local/bin/
COPY data data

ENTRYPOINT ["docker-entrypoint.sh"]