#!/bin/bash
set -euo pipefail

echo "DuckDB ETLプロセスを開始します..."
echo "開始時刻: $(date -Iseconds)"

# DuckDB変換処理を実行 (S3から読み込み、S3へ書き込み)
# :memory: でインメモリデータベースを使用（ディスクにファイルを作らない）
# 処理完了後、メモリは自動的に解放される
if duckdb :memory: < /app/transform.sql; then
    echo "✓ ETL処理が正常に完了しました"
    echo "終了時刻: $(date -Iseconds)"
    exit 0
else
    echo "✗ ETL処理が失敗しました"
    echo "失敗時刻: $(date -Iseconds)"
    exit 1
fi
