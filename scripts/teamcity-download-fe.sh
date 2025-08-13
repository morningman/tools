#!/bin/bash

# 使用方法: ./teamcity-download-fe.sh 140328

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "用法: $0 <teamcity-id>"
    exit 1
fi

ID="$1"
OSS_PATH="oss://selectdb-qa-test/internal/teamcity-${ID}"

echo "获取文件列表..."
# 获取所有 fe_artifacts.tar.gz 的路径
FILES=$(rclone ls "$OSS_PATH" | awk '{print $2}' | grep '/fe_artifacts.tar.gz$')

if [ -z "$FILES" ]; then
    echo "未找到 fe_artifacts.tar.gz 文件"
    exit 0
fi

# 去重
FILES=$(echo "$FILES" | sort -u)

# 逐个处理
for FILE in $FILES; do
    IP=$(echo "$FILE" | cut -d'/' -f1)
    echo "处理 IP: $IP"

    # 下载文件
    echo "下载: $FILE"
    rclone copy "${OSS_PATH}/${FILE}" ./ --progress

    # 解压
    echo "解压 fe_artifacts.tar.gz..."
    tar xzf fe_artifacts.tar.gz

    # 重命名
    NEW_DIR="fe-${IP}"
    mv fe "$NEW_DIR"
    echo "已重命名为: $NEW_DIR"

    # 删除原压缩包
    rm -f fe_artifacts.tar.gz
done

echo "全部处理完成！"

