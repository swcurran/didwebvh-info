#!/bin/bash

# A script to prep for testing of mkdocs generation, and then to clean up after
# Called as the file preparation step in the .github/workflows/publish-docs Git Hub Action
#
# Add argument "clean" to undo these changes when just being used for testing.
#    WARNING -- does a `git checkout -- docs` so you will lose any others changes you make!!!

if [[ "$1" == "clean" ]]; then
  rm -f docs/CODE_OF_CONDUCT.md \
        docs/CONTRIBUTING.md \
        docs/MAINTAINERS.md
    ## Update the following line to "clean" any changes made below to files that remain in the `docs` folder
    # git checkout -- docs/README.md 
else
    # Copy all of the root level md files into the docs folder for deployment, tweaking the relative paths and removing the "refs"
    for i in *.md; do sed \
      -e "s#docs/#./#g" \
      $i >docs/$i; done
    # Fix image references in demo documents so they work in GitHub and mkdocs
    # for i in docs/demo/AriesOpenAPIDemo.md docs/demo/AliceGetsAPhone.md; do sed -e "s#src=.assets#src=\"../assets#" $i >$i.tmp; mv $i.tmp $i; done
fi
