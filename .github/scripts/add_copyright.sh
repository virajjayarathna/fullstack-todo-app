#!/bin/bash

# Define variables
current_year=$(date +%Y)
current_date=$(date +%Y-%m-%d)  # YYYY-MM-DD format
copyright_text="© [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved. $current_date"

# Define file types to scan
file_extensions="js|jsx|ts|tsx|html|css|yml"

# Get staged files that match the extensions (ignoring .gitignore)
files=$(git diff --cached --name-only --diff-filter=ACM | grep -E "\.($file_extensions)$" | grep -v ".gitignore")

for file in $files; do
  if ! grep -q "© \[2005\] \[KingIT Solutions" "$file"; then
    case "$file" in
      *.js|*.jsx|*.ts|*.tsx)
        comment="// $copyright_text"
        ;;
      *.html)
        comment="<!-- $copyright_text -->"
        ;;
      *.css)
        comment="/* $copyright_text */"
        ;;
      *.yml)
        comment="# $copyright_text"
        ;;
      *)
        echo "Skipping unknown file type: $file"
        continue
        ;;
    esac

    # Prepend copyright header
    echo -e "$comment\n\n$(cat "$file")" > "$file"
    git add "$file"
  fi
done
