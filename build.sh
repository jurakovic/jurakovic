#!/bin/bash

file="README.md"

cat << EOF > $file

#### Technologies / Tools / Skills

<p align="center">
EOF

tech=$(jq -r '.tech[] | "	<img alt=\"tech\" src=\"\(.)\" />"' data.json)
echo "$tech" >> $file

cat << EOF >> $file
</p>

#### Some Projects

EOF

user="jurakovic"
projects=$(jq -r '.projects[]' data.json)

jq -c '.projects[]' data.json | while read i; do
  repo=$(echo "$i" | jq -r '.repo')
  icon=$(echo "$i" | jq -r '.icon')
  pages=$(echo "$i" | jq -r '.pages')
  mapfile -t descr < <(echo "$i" | jq -r '.description[]')

  echo "- $icon [$repo](https://github.com/$user/$repo)" >> $file

  for line in "${descr[@]}"; do
    echo "	- $line" >> $file
  done

  if [ $pages == "true" ]
  then
    echo "	- <https://$user.github.io/$repo/>" >> $file
  fi
done

cat << EOF >> $file

#### Language Stats

![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=jurakovic&layout=compact&hide=java&theme=github_dark)
EOF

# fix line ending
dos2unix -q "$file"

echo "Done"
