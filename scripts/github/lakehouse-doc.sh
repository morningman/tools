#!/bin/bash

REPO="apache/doris-website"
TARGET_DIRS=("docs/lakehouse" "i18n/zh-CN/docusaurus-plugin-content-docs/current/lakehouse/")

echo "Fetching open PRs in $REPO that modify any of: ${TARGET_DIRS[*]}"
echo

# 获取所有 open PR
prs=$(gh pr list -R "$REPO" --state open --limit 1000 --json number,title,url)
total=$(echo "$prs" | jq length)
echo "Total open PRs: $total"
echo

count=0
echo "$prs" | jq -c '.[]' | while read -r pr; do
  ((count++))
  PR_NUMBER=$(echo "$pr" | jq -r '.number')
  PR_TITLE=$(echo "$pr" | jq -r '.title')
  PR_URL=$(echo "$pr" | jq -r '.url')

  # 进度提示
  echo -ne "[${count}/${total}] Checking PR #${PR_NUMBER} ...\r"

  MODIFIED_FILES=$(gh pr view "$PR_NUMBER" -R "$REPO" --json files \
    | jq -r '.files[].path')

  MATCHED=false
  for dir in "${TARGET_DIRS[@]}"; do
    if echo "$MODIFIED_FILES" | grep -q "^$dir"; then
      MATCHED=true
      break
    fi
  done

  if [ "$MATCHED" = true ]; then
    echo -e "\n✅ Found match in PR #${PR_NUMBER}"
    echo "$PR_TITLE"
    echo "$PR_URL"
    echo
  fi
done

echo -e "\nDone."

