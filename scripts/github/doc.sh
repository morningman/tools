#!/bin/bash

REPO="apache/doris-website"
AUTHORS=("vinlee19" "heguanhui" "ghkang98" "yoock" "morningman" "BePPPower" "kaka11chen" "CalvinKirs" "wuwenchi" "zy-kkk" "suxiaogang223" "hubgeter")

for author in "${AUTHORS[@]}"; do
  echo "=== Open PRs by $author ==="

  gh pr list -R "$REPO" --author "$author" --state open --limit 500 --json url \
    | jq -r '.[].url'

  echo
done

