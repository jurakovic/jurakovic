#!/bin/bash

user="jurakovic"
json="data.json"
readme="README.md"

cat << EOF > $readme

#### Technologies / Tools / Skills

<p align="center">
EOF

tech=$(jq -r '.tech[] | "	<img alt=\"tech\" src=\"\(.)\" />"' "$json")
echo "$tech" >> $readme

cat << EOF >> $readme
</p>

#### Some Projects

EOF

projects=$(jq -r '.projects[]' "$json")

jq -c '.projects[]' "$json" | while read i; do
  repo=$(echo "$i" | jq -r '.repo')
  icon=$(echo "$i" | jq -r '.icon')
  pages=$(echo "$i" | jq -r '.pages')
  mapfile -t descr < <(echo "$i" | jq -r '.description[]')

  echo "- $icon [$repo](https://github.com/$user/$repo)" >> $readme

  for line in "${descr[@]}"; do
    echo "	- $line" >> $readme
  done

  if [ "$pages" == "true" ]
  then
    echo "	- <https://$user.github.io/$repo/>" >> $readme
  fi
done

cat << EOF >> $readme

#### Language Stats

![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=$user&layout=compact&hide=java&theme=github_dark)
EOF

# fix line ending
dos2unix -q "$readme"

echo "Done"
