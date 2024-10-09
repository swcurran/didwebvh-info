#!/bin/bash

# A script to prep for testing of mkdocs generation, and then to clean up after
# Called as the file preparation step in the .github/workflows/publish-docs Git Hub Action
#
# Add argument "clean" to undo these changes when just being used for testing.
#    WARNING -- does a `git checkout -- docs` so you will lose any others changes you make!!!

if [[ "$1" == "clean" ]]; then
  rm -f docs/root_*
else
    # Copy all of the root level md files into the docs folder for deployment, tweaking the relative paths and removing the "refs"
    # Preface their names with "root_"
    for i in *.md; do sed \
      -e "s#docs/#./#g" \
      $i >docs/root_$i; done
fi
