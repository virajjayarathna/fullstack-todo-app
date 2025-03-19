#!/bin/bash

# Define the file extensions to check
files=$(git ls-files | grep -E '\.(js|jsx|ts|tsx|py|java|cpp|h|cs|html|css|yml|yaml)$')

for file in $files; do
  # Skip .gitignore files
  if [[ "$file" == ".gitignore" ]]; then
    continue
  fi

  # Determine the comment syntax based on file extension
  case "$file" in
    *.js|*.jsx|*.ts|*.tsx|*.java|*.cpp|*.h|*.cs)
      comment="// Copyright (c) $(date +%Y) IT Solutions. All rights reserved.\n\n"
      ;;
    *.py|*.yml|*.yaml)
      comment="# Copyright (c) $(date +%Y) IT Solutions. All rights reserved.\n\n"
      ;;
    *.html|*.css)
      comment="<!-- Copyright (c) $(date +%Y) IT Solutions. All rights reserved. -->\n\n"
      ;;
    *)
      continue
      ;;
  esac

  # Check if the file already contains a copyright header
  if ! grep -q "Copyright" "$file"; then
    echo -e "$comment$(cat $file)" > "$file"
    git add "$file"
  fi
done
