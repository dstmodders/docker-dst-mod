#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
DISTS=('debian' 'alpine')
JSON="$(cat ./versions.json)"
REPOSITORY='https://github.com/dstmodders/docker-dst-mod'
VERSIONS_KEYS=()

mapfile -t VERSIONS_KEYS < <(jq -r 'keys[]' <<< "$JSON")
# shellcheck disable=SC2207
IFS=$'\n' VERSIONS_KEYS=($(sort -rV <<< "${VERSIONS_KEYS[*]}")); unset IFS

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly JSON
readonly REPOSITORY
readonly VERSIONS_KEYS

function print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

cd "$BASE_DIR" || exit 1

printf "## Supported tags and respective \`Dockerfile\` links\n\n"

for key in "${VERSIONS_KEYS[@]}"; do
  for dist in "${DISTS[@]}"; do
    latest=$(jq -r ".[$key] | .latest" <<< "$JSON")

    tag_dist="$dist"

    tags="\`$tag_dist\`"
    case "$dist" in
      debian)
        if [ "$latest" == 'true' ]; then
          tags="$tags, \`latest\`"
        fi
      ;;
    esac

    print_url "$tags" "$COMMIT_ID" "$dist"
  done
done
