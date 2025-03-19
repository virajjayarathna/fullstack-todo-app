#!/bin/bash

# Define the files to check (avoid .gitignore files)
files=$(git ls-files | grep -E '\.(js|py|java|cpp|h|cs)$')

for file in $files; do
  if ! grep -q "Copyright" "$file"; then
    current_year=$(date +%Y)
    company_name="IT Solutions"
    copyright_header="// Copyright (c) $current_year $company_name. All rights reserved.\n\n"
    
    # Add header to the file
    echo -e "$copyright_header$(cat $file)" > "$file"
    
    # Stage the file
    git add "$file"
  fi
done
