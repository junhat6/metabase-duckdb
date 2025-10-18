FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y bash curl unzip ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip -o duckdb.zip && \
    unzip duckdb.zip -d /usr/local/bin && \
    rm duckdb.zip && \
    chmod +x /usr/local/bin/duckdb

WORKDIR /app
COPY transform.sql run_etl.sh ./

ENTRYPOINT ["/bin/bash", "/app/run_etl.sh"]
