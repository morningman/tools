#!/bin/bash

REPO="apache/doris"
AUTHORS=("XnY-wei", "vinlee19", "heguanhui", "ghkang98", "yoock", "morningman", "BePPPower", "kaka11chen", "CalvinKirs", "wuwenchi", "zy-kkk", "suxiaogang223", "hubgeter")

LABELS=("dev/3.1.x")

LABEL_FILTER=""
for label in "${LABELS[@]}"; do
  [[ -n "$LABEL_FILTER" ]] && LABEL_FILTER+=" or "
  LABEL_FILTER+="(map(.name) | index(\"$label\"))"
done

for author in "${AUTHORS[@]}"; do
  echo "=== PRs by $author ==="

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

  echo
done
