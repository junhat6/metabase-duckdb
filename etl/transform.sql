-- DuckDB ETL Script: Transform JSONL.gz to Parquet
-- Reference: https://zenn.dev/shiguredo/articles/duckdb-jsonlines-log
-- Reads directly from S3, transforms, and writes back to S3

-- Install and load required extensions
INSTALL httpfs;
INSTALL json;
LOAD httpfs;
LOAD json;

-- Configure S3 credentials from environment variables
SET s3_region='${AWS_DEFAULT_REGION}';
SET s3_access_key_id='${AWS_ACCESS_KEY_ID}';
SET s3_secret_access_key='${AWS_SECRET_ACCESS_KEY}';

-- ============================================================================
-- Step 1: Read all log-*.jsonl.gz files from S3
-- ============================================================================

CREATE OR REPLACE TABLE raw_logs AS
SELECT *
FROM read_json_auto(
    '${S3_INPUT_PATTERN}',
    format='newline_delimited',
    filename=true,
    ignore_errors=true,
    maximum_object_size=10485760
);

-- ============================================================================
-- Step 2: Transform and clean the data
-- ============================================================================
-- Customize based on your actual log schema

CREATE OR REPLACE TABLE cleaned_logs AS
SELECT *
FROM raw_logs
-- Add WHERE clause for filtering if needed
;

-- ============================================================================
-- Step 3: Export to Parquet directly to S3
-- ============================================================================

COPY cleaned_logs TO '${S3_OUTPUT_PATH}' (
    FORMAT PARQUET,
    COMPRESSION 'ZSTD'
);
