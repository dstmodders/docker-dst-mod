#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID=$(git rev-parse --verify HEAD)
DISTS=('debian' 'alpine')
URL='https://github.com/dstmodders/docker-dst-mod'
VERSIONS=()

mapfile -t VERSIONS < <(jq -r 'keys[]' ./versions.json)
IFS=$'\n' VERSIONS=($(sort -rV <<< "${VERSIONS[*]}")); unset IFS

readonly BASE_DIR
readonly COMMIT_ID
readonly DISTS
readonly URL
readonly VERSIONS

# https://stackoverflow.com/a/17841619
function join_by {
  local d="${1-}"
  local f="${2-}"
  if shift 2; then
    printf %s "$f" "${@/#/$d}";
  fi
}

function jq_value {
  local from="$1"
  local key="$2"
  local name="$3"
  jq -r ".[${key}] | .${name}" "${from}"
}

function print_url() {
  local tags="$1"
  local commit="$2"
  local dist="$3"
  local url="[$tags](${URL}/blob/${commit}/${dist}/Dockerfile)"
  echo "- ${url}"
}

cd "${BASE_DIR}" || exit 1

printf "## Supported tags and respective \`Dockerfile\` links\n\n"

for v in "${VERSIONS[@]}"; do
  for dist in "${DISTS[@]}"; do
    commit="${COMMIT_ID}"
    latest=$(jq_value ./versions.json "${v}" 'latest')

    tag_dist="${dist}"

    tags=''
    if [ "${dist}" == 'debian' ]; then
      tags="\`${tag_dist}\`"
      if [ "${latest}" == 'true' ]; then
        tags="${tags}, \`latest\`"
      fi
    else
      tags="\`${tag_dist}\`"
    fi

    print_url "${tags}" "${commit}" "${dist}"
  done
done
