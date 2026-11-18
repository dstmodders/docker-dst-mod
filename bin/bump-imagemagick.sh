#!/usr/bin/env bash
#
# Bump the ImageMagick version.
#
# Usage:
#   bump-imagemagick.sh [flags] [<version>]
#
# Examples:
#   bump-imagemagick.sh
#   bump-imagemagick.sh -d 7.1.1-39
#   bump-imagemagick.sh 7.1.1-39
#
# Arguments:
#   <version>       ImageMagick version
#
# Flags:
#   -c, --commit    Commit changes
#   -d, --dry-run   Only check and don't apply or commit any changes
#   -h, --help      Show this help message
#
# Environment Variables:
#   NO_COLOR        Set to 1 to disable terminal colors
#                   (see no-color.org, default "0")
#
set -euo pipefail

# define constants
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCKERHUB_START_LINE=6
JSON="$(cat "${BASE_DIR}/../versions.json")"
README_START_LINE=13

readonly BASE_DIR
readonly DOCKERHUB_START_LINE
readonly JSON
readonly README_START_LINE

# shellcheck disable=SC1091
source "${BASE_DIR}/common.sh"

# define defaults for environment variables
NO_COLOR="${NO_COLOR:-0}"

# define flags
FLAG_COMMIT=0
FLAG_DRY_RUN=0

summary() {
  local old_version="$1"
  local new_version="$2"
  local files=(
    'DOCKERHUB.md'
    'README.md'
    'alpine/Dockerfile'
    'debian/Dockerfile'
    'versions.json'
  )

  print_step_dotted 'Printing affected files'
  printf '\n'
  print_separator
  mapfile -t sorted_files < <(printf '%s\n' "${files[@]}" | LC_ALL=C sort)
  for file in "${sorted_files[@]}"; do
    printf '%s\n' "${file}"
  done

  print_separator
  print_step_dotted 'Setting current version' "${old_version}"
  print_step_success
  print_step_dotted 'Setting new version' "${new_version}"
  print_step_success
}

replace() {
  local old_version="$1"
  local new_version="$2"

  print_step_dotted 'Replacing'
  sed -i "${DOCKERHUB_START_LINE},\$s/\`${old_version}\`/\`${new_version}\`/g" ./DOCKERHUB.md
  sed -i "${README_START_LINE},\$s/\`${old_version}\`/\`${new_version}\`/g" ./README.md
  sed -i "s/\"${old_version}\"/\"${new_version}\"/" ./versions.json
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"${old_version}\"$/ARG IMAGEMAGICK_VERSION=\"${new_version}\"/" ./alpine/Dockerfile
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"${old_version}\"$/ARG IMAGEMAGICK_VERSION=\"${new_version}\"/" ./debian/Dockerfile
  print_step_success
}

cd "${BASE_DIR}/.." || exit 1

new_version=''

while [ $# -gt 0 ]; do
  key="$1"
  case "${key}" in
    -c | --commit)
      FLAG_COMMIT=1
      ;;
    -d | --dry-run)
      FLAG_DRY_RUN=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      die 'unrecognized flag'
      ;;
    *)
      new_version="${key}"
      ;;
  esac
  shift 1
done

readonly FLAG_COMMIT
readonly FLAG_DRY_RUN

trap interrupt SIGINT

old_version="$(jq -r '.[0].imagemagick_version' <<< "${JSON}")"

if [ -z "${new_version}" ]; then
  printf 'Current version: %s\n' "${old_version}"
  while [ -z "${new_version}" ]; do
    read -rp 'Enter new version: ' new_version
    if [ -z "${new_version}" ]; then
      print_error 'empty version'
    fi
  done
  print_separator
fi

summary "${old_version}" "${new_version}"
if [ "${FLAG_DRY_RUN}" -eq 1 ]; then
  complete 3 'Dry-run completed'
fi

print_separator
replace "${old_version}" "${new_version}"

if [ "${FLAG_COMMIT}" -eq 1 ]; then
  print_step_dotted 'Committing'
  if [ "${old_version}" != "${new_version}" ]; then
    git add \
      DOCKERHUB.md \
      README.md \
      alpine/Dockerfile \
      debian/Dockerfile \
      versions.json
    if [ -n "$(git diff --cached --name-only)" ]; then
      printf '\n'
      print_separator
      git commit -m "Bump ImageMagick from ${old_version} to ${new_version}"
    else
      print_step_skipped
    fi
  else
    print_step_skipped
  fi
fi

complete 2 'Bump completed'
