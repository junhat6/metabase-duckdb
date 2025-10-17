#!/bin/bash
set -euo pipefail

# S3 paths - read all log-*.jsonl.gz files from raw/
export S3_INPUT_PATTERN="s3://${S3_INPUT_BUCKET}/raw/log-*.jsonl.gz"
export S3_OUTPUT_PATH="s3://${S3_OUTPUT_BUCKET}/processed/whisper_log.parquet"

echo "Input:  ${S3_INPUT_PATTERN}"
echo "Output: ${S3_OUTPUT_PATH}"

# Run DuckDB transformation (reads from S3, writes to S3)
duckdb :memory: < /app/transform.sql

echo "Done: ${S3_OUTPUT_PATH}"
