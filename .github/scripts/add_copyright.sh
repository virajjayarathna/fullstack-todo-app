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
    # JavaScript, TypeScript, React files
    *.js|*.jsx|*.ts|*.tsx)
      comment="// © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved.$(date +%Y)\n\n"
      ;;
    
    # Python, YAML files
    *.py|*.yml|*.yaml)
      comment="# © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved.$(date +%Y)\n\n"
      ;;
    
    # HTML files
    *.html)
      comment="<!-- © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved.$(date +%Y) -->\n\n"
      ;;
    
    # CSS files
    *.css)
      comment="/* © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved.$(date +%Y) */\n\n"
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
