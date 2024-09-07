#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCKERHUB_START_LINE=6
JSON="$(cat "$BASE_DIR/../versions.json")"
PROGRAM="$(basename "$0")"
README_START_LINE=13

readonly BASE_DIR
readonly DOCKERHUB_START_LINE
readonly JSON
readonly PROGRAM
readonly README_START_LINE

usage() {
  echo -e "Bump the latest ImageMagick version.

    Usage:
      $PROGRAM [flags] [version]

    Flags:
      -c, --commit   commit changes
      -h, --help     help for $PROGRAM" | sed -E 's/^ {4}//'
}

print_bold() {
  local value="$1"
  local output="${3:-1}"

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

  print_bold '[FILES]'
  printf '\n\n'
  mapfile -t sorted_files < <(printf "%s\n" "${files[@]}" | LC_ALL=C sort)
  for file in "${sorted_files[@]}"; do
    echo "$file"
  done

  printf '\n'
  print_bold '[VERSION]'
  printf '\n\n'

  echo "Current: $old_version"
  echo "New: $new_version"
}

replace() {
  local old_version="$1"
  local new_version="$2"

  printf 'Replacing...'
  sed -i "$DOCKERHUB_START_LINE,\$s/\`$old_version\`/\`$new_version\`/g" ./DOCKERHUB.md
  sed -i "$README_START_LINE,\$s/\`$old_version\`/\`$new_version\`/g" ./README.md
  sed -i "s/\"$old_version\"/\"$new_version\"/" ./versions.json
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"$old_version\"$/ARG IMAGEMAGICK_VERSION=\"$new_version\"/" ./alpine/Dockerfile
  sed -i "s/^ARG IMAGEMAGICK_VERSION=\"$old_version\"$/ARG IMAGEMAGICK_VERSION=\"$new_version\"/" ./debian/Dockerfile
  printf ' Done\n'
}

cd "$BASE_DIR/.." || exit 1

commit=0

while [ $# -gt 0 ]; do
  key="$1"
  case "$key" in
    -c|--commit)
      commit=1
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
      new_version="$key"
      ;;
  esac
  shift 1
done

old_version="$(jq -r '.[0].imagemagick_version' <<< "$JSON")"

if [ -z "$new_version" ]; then
  echo "Current version: $old_version"
  read -rp "Enter new latest version: " new_version
  echo '---'
fi

summary "$old_version" "$new_version"
echo '---'
replace "$old_version" "$new_version"

if [ "$commit" -eq 1 ]; then
  printf 'Committing...'
  git add \
    DOCKERHUB.md \
    README.md \
    alpine/Dockerfile \
    debian/Dockerfile \
    versions.json
  if [ -n "$(git diff --cached --name-only)" ]; then
    printf '\n'
    echo '---'
    git commit -m "Bump ImageMagick from $old_version to $new_version"
  else
    printf ' Skipped\n'
  fi
fi

exit 0
