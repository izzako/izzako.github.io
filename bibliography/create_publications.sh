
#!/bin/bash

# Step 1: Convert refs.md to publications.md using Pandoc
echo "Generating publications.md from refs.md..."
pandoc refs.md --citeproc -t markdown -s -o publications.md

# Step 2: Use gsed to convert citations to bullet points
echo "Converting citation blocks into bullet points..."
gsed -n '/^::: {#ref-/,/^:::/ {
  /^::: {#ref-/c\
- 
  /^:::/d
  p
}' publications.md > publication_body.md


# Step 3: Retain the first 10 lines (YAML + intro text)
echo "Retaining front matter and intro..."
head -n 10 publications.md > header.md

# Step 4: Highlight author name in bold
# Replace both abbreviated and full forms
echo "Highlighting author name..."
gsed -i -e 's/Wijanarko, M\. I\./**Wijanarko, M. I.**/g' \
        -e '/\*\*Wijanarko, M\. I\.\*\*/! s/Wijanarko, M\./**Wijanarko, M.**/g' publication_body.md

# Combine header and processed citation list
echo "Merging header and body..."
cat header.md publication_body.md > publications.md

# Clean up temporary files
rm header.md publication_body.md

echo "Done. See: publications.md"