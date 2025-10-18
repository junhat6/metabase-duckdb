install httpfs;

load httpfs;

-- s3認証情報を設定（ec2のiamロールを使用）
create
or replace secret secret (
  type s3,
  provider credential_chain,
  chain 'instance'
);

-- s3上のparquetファイルを直接クエリ
select
  *
from
  read_parquet (
    's3://duckdb-metabase-data-junichi/processed/cleaned-data.parquet'
  );
