#!/bin/bash

# template
cat << EOF > READMEx.md

#### Technologies / Tools / Skills

<p align="center">
__TECH__
</p>

#### Some Projects

__PROJECTS__

#### Language Stats

![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=jurakovic&layout=compact&hide=java&theme=github_dark)

EOF
# end of template

# load tech stack
tech=$(jq -r '.tech[] | "    <img alt=\"tech\" src=\"\(.)\" />"' data.json)

# escale special scaracters (src: https://unix.stackexchange.com/a/519305)
tech=$(sed -e 's/[&\\/]/\\&/g; s/$/\\/' -e '$s/\\$//' <<<"$tech")

# replace placeholder in file
sed -i "s/__TECH__/$tech/" READMEx.md
