#!/bin/bash

REPO="apache/doris"

AUTHORS=("yx-keith" "cambyzju" "liutang123" "qzsee" "felixwluo" "XnY-wei" "vinlee19" "heguanhui" "ghkang98" "yoock" "morningman" "BePPPower" "kaka11chen" "CalvinKirs" "wuwenchi" "zy-kkk" "suxiaogang223" "hubgeter" "zgxme", "zhangstar333", "xylaaaaa")

LABELS=("dev/4.0.x")
EXCLUDE_LABELS=()  # 可以为空，例如 EXCLUDE_LABELS=()

# 构造 LABELS 的 jq 过滤条件
LABEL_FILTER=""
for label in "${LABELS[@]}"; do
  [[ -n "$LABEL_FILTER" ]] && LABEL_FILTER+=" or "
  LABEL_FILTER+="(map(.name) | index(\"$label\"))"
done

# 构造 EXCLUDE_LABELS 的 jq 过滤条件
EXCLUDE_FILTER=""
if [[ ${#EXCLUDE_LABELS[@]} -gt 0 ]]; then
  for label in "${EXCLUDE_LABELS[@]}"; do
    [[ -n "$EXCLUDE_FILTER" ]] && EXCLUDE_FILTER+=" or "
    EXCLUDE_FILTER+="(map(.name) | index(\"$label\"))"
  done
fi

for author in "${AUTHORS[@]}"; do
  echo "=== PRs by $author ==="

  if [[ -n "$EXCLUDE_FILTER" ]]; then
    # 有 EXCLUDE_LABELS 时
    gh pr list -R "$REPO" --author "$author" --state all --limit 500 --json url,labels,state,mergedAt \
      | jq -r '[
          .[]
          | select(.labels | '"$LABEL_FILTER"')
          | select(.labels | ('"$EXCLUDE_FILTER"') | not)
          | {
              url: .url,
              status: (if .state == "CLOSED" and .mergedAt != null then "MERGED" else .state end)
            }
          | select(.status != "CLOSED")
        ]
        | .[]
        | "\(.status)  \(.url)"'
  else
    # 没有 EXCLUDE_LABELS 时
    gh pr list -R "$REPO" --author "$author" --state all --limit 500 --json url,labels,state,mergedAt \
      | jq -r '[
          .[]
          | select(.labels | '"$LABEL_FILTER"')
          | {
              url: .url,
              status: (if .state == "CLOSED" and .mergedAt != null then "MERGED" else .state end)
            }
          | select(.status != "CLOSED")
        ]
        | .[]
        | "\(.status)  \(.url)"'
  fi

  echo
done

