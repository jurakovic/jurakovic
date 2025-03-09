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

# load projects
projects=$(jq -r '.projects[]' data.json)

jq -c '.projects[]' data.json | while read i; do
  #echo "$i"

  name=$(echo "$i" | jq -r '.name')
  icon=$(echo "$i" | jq -r '.icon')
  pages=$(echo "$i" | jq -r '.pages')
  mapfile -t descr < <(echo "$i" | jq -r '.description[]')
  echo "$name"
  echo "$icon"
  echo "$pages"
  printf '%s\n' "${descr[@]}"
done
