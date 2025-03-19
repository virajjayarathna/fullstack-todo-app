#!/bin/bash

# Function to add copyright header
add_copyright() {
  local file="$1"
  local date_str="$(date +"%Y-%m-%d")"

  # Skip .gitignore files
  if [[ "$file" == ".gitignore" ]]; then
    return
  fi

  # Determine the comment syntax based on file extension
  case "$file" in
    *.js|*.jsx|*.ts|*.tsx)
      comment="// © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved. $date_str\n\n"
      ;;
    *.py|*.yml|*.yaml)
      comment="# © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved. $date_str\n\n"
      ;;
    *.html)
      comment="<!-- © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved. $date_str -->\n\n"
      ;;
    *.css)
      comment="/* © [2005] [KingIT Solutions (Pvt) Ltd]. All Rights Reserved. $date_str */\n\n"
      ;;
    *)
      return
      ;;
  esac

  # Check if the file already contains the copyright notice
  if ! grep -q "© \[2005\] \[KingIT Solutions (Pvt) Ltd\]" "$file"; then
    tmp_file=$(mktemp)
    echo -e "$comment$(cat "$file")" > "$tmp_file"
    mv "$tmp_file" "$file"
    git add "$file"
    echo "Updated: $file"
  fi
}

# Initial scan for existing files
files=$(git ls-files | grep -E '\.(js|jsx|ts|tsx|py|java|cpp|h|cs|html|css|yml|yaml)$')
for file in $files; do
  add_copyright "$file"
done

echo "Initial scan completed. Now watching for file changes..."

# Continuous monitoring for new changes
while true; do
  changed_file=$(inotifywait -e close_write,moved_to,create --format "%w%f" -q .)
  if [[ $changed_file =~ \.(js|jsx|ts|tsx|py|java|cpp|h|cs|html|css|yml|yaml)$ ]]; then
    add_copyright "$changed_file"
  fi
done
