FROM alpine:3.19

RUN apk add --no-cache bash curl && \
    curl https://install.duckdb.org | sh

WORKDIR /app
COPY transform.sql run_etl.sh ./

ENTRYPOINT ["/bin/bash", "/app/run_etl.sh"]
