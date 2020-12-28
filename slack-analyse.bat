#!/bin/bash

set -ue -o pipefail

if [ "${2:-}" != "" ]; then
    echo "引数が多過ぎます"
    echo "パスをダブルクォーテーションで囲っていない可能性があります"
    exit 1
fi

TARGET_PATH="$(wslpath "${1:-}")"

if [ ! -d "${TARGET_PATH}" ]; then
    echo "ディレクトリが存在しません"
    echo "期待されるディレクトリ: ${1:-}"
    exit 1
fi

SCRIPT_DIR=$(cd $(dirname "$(readlink -fn "${0}")"); pwd)
CREATE_MASTER_PY="${SCRIPT_DIR}/createMasterCsv.py"
CREATE_TALK_PY="${SCRIPT_DIR}/createTalkCsv.py"

cd "${TARGET_PATH}"

if [ -e "./data" ]; then
    echo "「$(wslpath -m "${TARGET_PATH}/")\\data」 の作成を試みましたが、既に存在するため失敗しました。"
    echo "該当ファイル/フォルダを削除したのちに再度実行してください"
    exit 1
fi

ln -s . ./data

python3 "${CREATE_MASTER_PY}"
python3 "${CREATE_TALK_PY}"

rm ./data

exit 0
