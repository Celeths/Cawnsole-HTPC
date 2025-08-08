#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/Cawnonical Mono-Glyph Icon Suite"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Source directory does not exist: $SOURCE_DIR"
  exit 1
fi

accented_dir="${SOURCE_DIR} (Accented)"
cp -R "$SOURCE_DIR" "$accented_dir"
theme_file="${accented_dir}/index.theme"
if [[ -f "$theme_file" ]]; then
  sed -i '' "s/Unfilled/Accented/g" "$theme_file"
fi
find "$accented_dir" -type f -name '*.svg' -exec sed -i '' -E 's@(<svg[^>]*>)@\1\
  <defs>\
    <style type="text/css" id="current-color-scheme">.ColorScheme-Highlight { color:#000000; }</style>\
  </defs>@' {} +
find "$accented_dir" -type f -name '*.svg' -exec sed -i '' \
  -e '1,/<path / s|<path |<path class="ColorScheme-Highlight" fill="currentColor" |' \
  {} +

textfill_dir="${SOURCE_DIR} (Text-Fill)"
cp -R "$SOURCE_DIR" "$textfill_dir"
theme_file="${textfill_dir}/index.theme"
if [[ -f "$theme_file" ]]; then
  sed -i '' "s/Unfilled/Text-Fill/g" "$theme_file"
fi
find "$textfill_dir" -type f -name '*.svg' -exec sed -i '' -E 's@(<svg[^>]*>)@\1\
  <defs>\
    <style type="text/css" id="current-color-scheme">.ColorScheme-Text { color:#000000; }</style>\
  </defs>@' {} +
find "$textfill_dir" -type f -name '*.svg' -exec sed -i '' \
  -e '1,/<path / s|<path |<path class="ColorScheme-Text" fill="currentColor" |' \
  {} +

declare -A colors=(
  [Lime]="140, 220, 60"
  [Green]="55, 200, 90"
  [Mint]="0, 200, 170"
  [Teal]="50, 190, 200"
  [Cyan]="50, 175, 230"
  [Blue]="0, 125, 255"
  [Indigo]="90, 90, 215"
  [Violet]="175, 80, 225"
  [Magenta]="255, 70, 180"
  [Pink]="255, 60, 110"
  [Red]="255, 60, 50"
  [Orange]="255, 150, 0"
  [Yellow]="255, 205, 0"
  [Brown]="165, 135, 95"
  [White]="255, 255, 255"
  [Grey]="127, 127, 127"
  [Black]="0, 0, 0"
)

for color in "${!colors[@]}"; do
  rgb="${colors[$color]}"
  new_dir="${SOURCE_DIR} (${color})"
  cp -R "$SOURCE_DIR" "$new_dir"
  theme_file="${new_dir}/index.theme"
  if [[ -f "$theme_file" ]]; then
    sed -i '' "s/Unfilled/${color}/g" "$theme_file"
  fi
  find "$new_dir" -type f -name '*.svg' -exec sed -i '' \
    -e "1,/<path / s|<path |<path fill=\"rgb(${rgb})\" |" \
    {} +
done