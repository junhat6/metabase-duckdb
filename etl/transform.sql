-- DuckDB ETLスクリプト: JSONL.gz → Parquet変換
-- 参考: https://zenn.dev/shiguredo/articles/duckdb-jsonlines-log
-- S3から直接読み込み、変換処理を行い、S3へ書き戻す

-- 必要な拡張機能をインストール・ロード
INSTALL httpfs;

INSTALL json;

LOAD httpfs;

LOAD json;

-- 環境変数からS3認証情報を設定
CREATE
OR REPLACE SECRET secret (
  TYPE s3,
  PROVIDER credential_chain,
  CHAIN 'instance'
);

-- ============================================================================
-- Step 1: S3からすべてのlog-*.jsonl.gzファイルを読み込み
-- ============================================================================
CREATE
OR REPLACE TABLE raw_logs AS
SELECT
  *
FROM
  read_json_auto (
    's3://duckdb-metabase-data-junichi/raw/log-*.jsonl.gz',
    filename = true
  );

-- ============================================================================
-- Step 2: データの変換・クリーニング
-- ============================================================================
-- 実際のログスキーマに応じてカスタマイズしてください
CREATE
OR REPLACE TABLE cleaned_logs AS
SELECT
  *
FROM
  raw_logs
  -- 必要に応じてWHERE句でフィルタリング
;

-- ============================================================================
-- Step 3: ParquetファイルとしてS3へ直接エクスポート
-- ============================================================================
COPY cleaned_logs TO 's3://duckdb-metabase-data-junichi/processed/cleaned-data.parquet' (FORMAT PARQUET, COMPRESSION 'ZSTD');
