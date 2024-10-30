#!/usr/bin/env bash

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COMMIT_ID="$(git rev-parse --verify HEAD)"
COMMIT_MESSAGE='Change tags in DOCKERHUB.md and README.md'
DISTS=('debian' 'alpine')
HEADING_FOR_OVERVIEW='## Overview'
HEADING_FOR_TAGS="## Supported tags and respective \`Dockerfile\` links"
JSON="$(cat ./versions.json)"
PROGRAM="$(basename "$0")"
REPOSITORY='https://github.com/dstmodders/docker-dst-mod'
VERSIONS_KEYS=()

mapfile -t VERSIONS_KEYS < <(jq -r 'keys[]' <<< "$JSON")
# shellcheck disable=SC2207
IFS=$'\n' VERSIONS_KEYS=($(sort -rV <<< "${VERSIONS_KEYS[*]}")); unset IFS

readonly BASE_DIR
readonly COMMIT_ID
readonly COMMIT_MESSAGE
readonly DISTS
readonly HEADING_FOR_OVERVIEW
readonly HEADING_FOR_TAGS
readonly JSON
readonly PROGRAM
readonly REPOSITORY
readonly VERSIONS_KEYS

# define flags
FLAG_COMMIT=0

usage() {
  cat <<EOF
Generate supported tags.

Usage:
  $PROGRAM [flags]

Flags:
  -c, --commit   commit changes
  -h, --help     help for $PROGRAM
EOF
}

print_bold() {
  local value="$1"
  local output="${2:-1}"

  if [ "$DISABLE_COLORS" = '1' ] || ! [ -t 1 ]; then
    printf '%s' "$value" >&"$output"
  else
    printf "$(tput bold)%s$(tput sgr0)" "$value" >&"$output"
  fi
}

print_bold_color() {
  local color="$1"
  local value="$2"
  local output="${3:-1}"

  if [ "$DISABLE_COLORS" = '1' ] || ! [ -t 1 ]; then
    printf '%s' "$value" >&"$output"
  else
    printf "$(tput bold)$(tput setaf "$color")%s$(tput sgr0)" "$value" >&"$output"
  fi
}

print_error() {
  print_bold_color 1 "error: $1" 2
  echo '' >&2
}

print_url() {
  local tags="$1"
  local commit="$2"
  local directory="$3"
  local url="[$tags]($REPOSITORY/blob/$commit/$directory/Dockerfile)"
  echo "- $url"
}

print_tags() {
  for key in "${VERSIONS_KEYS[@]}"; do
    for dist in "${DISTS[@]}"; do
      latest="$(jq -r ".[$key] | .latest" <<< "$JSON")"

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
}

replace() {
  local content="$1"
  for file in ./DOCKERHUB.md ./README.md; do
    sed -i "/$HEADING_FOR_TAGS/,/$HEADING_FOR_OVERVIEW/ {
      /$HEADING_FOR_TAGS/!{
        /$HEADING_FOR_OVERVIEW/!d
      }
      /$HEADING_FOR_TAGS/!b
      r /dev/stdin
      d
    }" "$file" <<< "$content"
  done
}

cd "$BASE_DIR/.." || exit 1

while [ $# -gt 0 ]; do
  key="$1"
  case "$key" in
    -c|--commit)
      FLAG_COMMIT=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      print_error 'unrecognized flag'
      exit 1
      ;;
    *)
      ;;
  esac
  shift 1
done

# define extra constants
readonly FLAG_COMMIT

printf "%s\n\n" "$HEADING_FOR_TAGS"

if [ "$FLAG_COMMIT" -eq 1 ]; then
  tags="$(print_tags)"
  echo "$tags"
  echo '---'
  replace "$HEADING_FOR_TAGS"$'\n'$'\n'"$tags"$'\n'
  printf 'Committing...'
  git add ./DOCKERHUB.md ./README.md
  if [ -n "$(git diff --cached --name-only)" ]; then
    printf '\n'
    echo '---'
    git commit -m "$COMMIT_MESSAGE"
  else
    printf ' Skipped\n'
  fi
else
  print_tags
fi
