#!/bin/bash

# Get current year and date
current_year=$(date +%Y)
current_date=$(date +%Y-%m-%d)  # YYYY-MM-DD format
copyright_text="© [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved. $current_date"

# Define the file extensions to check
files=$(git ls-files | grep -E '\.(js|jsx|ts|tsx|py|java|cpp|h|cs|html|css|yml|yaml|sh)$')

for file in $files; do
  # Skip .gitignore files
  if [[ "$file" == ".gitignore" ]]; then
    continue
  fi

  # Determine the comment syntax based on file extension
  case "$file" in
    # JavaScript, TypeScript, React files
    *.js|*.jsx|*.ts|*.tsx)
      comment="// $copyright_text\n\n"
      ;;
    
    # Python, YAML, Shell scripts
    *.py|*.yml|*.yaml|*.sh)
      comment="# $copyright_text\n\n"
      ;;
    
    # HTML files
    *.html)
      comment="<!-- $copyright_text -->\n\n"
      ;;
    
    # CSS files
    *.css)
      comment="/* $copyright_text */\n\n"
      ;;
    
    * )
      continue
      ;;
  esac

  # Check if the file already contains the copyright header
  if ! grep -q "© \[2005\] \[KingIT Solutions" "$file"; then
    echo -e "$comment$(cat "$file")" > "$file"
    git add "$file"
  fi
done
