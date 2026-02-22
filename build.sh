#!/bin/bash

user="jurakovic"
json="data.json"
readme="README.md"

currRepo=$(basename -s .git $(git config --get remote.origin.url))
repoType="readme"

if [ $currRepo != $user ]; then
  repoType="githubio"
fi

echo "currRepo: $currRepo"
echo "repoType: $repoType"

if [ "$repoType" = "githubio" ]; then

  curl -Sso data.json https://raw.githubusercontent.com/jurakovic/jurakovic/refs/heads/master/data.json

  cat << EOF > $readme

<p align="center">
    <a href="https://github.com/$user">
        <img align="center" src="https://images.weserv.nl/?url=avatars.githubusercontent.com/u/17744091?v=4&h=260&w=260&fit=cover&mask=circle&maxage=1d" alt="$user" class="responsive-image" />
    </a>
</p>
<br>

EOF

else
  echo "" > $readme
fi

cat << EOF >> $readme
#### Technologies / Tools / Skills

<p align="center">
EOF


tech=$(jq -r '.tech[] | "    <img alt=\"tech\" src=\"\(.)\" />"' "$json")
echo "$tech" >> $readme

cat << EOF >> $readme
</p>

#### Some Projects

EOF

projects=$(jq -r '.projects[]' "$json")

jq -c '.projects[]' "$json" | while read i; do
  repo=$(echo "$i" | jq -r '.repo')
  icon=$(echo "$i" | jq -r '.icon')
  readme_show_pages=$(echo "$i" | jq -r '.readme_show_pages')
  githubio_show_pages=$(echo "$i" | jq -r '.githubio_show_pages')
  githubio_show_repo=$(echo "$i" | jq -r '.githubio_show_repo')
  mapfile -t descr < <(echo "$i" | jq -r '.description[]')
  mapfile -t readmeDescr < <(echo "$i" | jq -r '.readmeDescr[]?')

  if [ "$repoType" = "readme" ]; then

    echo "- $icon [**$repo**](https://github.com/$user/$repo)" >> $readme

    for line in "${descr[@]}"; do
      echo "    - $line" >> $readme
    done

    for line in "${readmeDescr[@]}"; do
      echo "    - $line" >> $readme
    done

    if [ "$readme_show_pages" == "true" ]
    then
      echo "    - <https://$user.github.io/$repo/>" >> $readme
    fi

  else # githubio

    if [ "$githubio_show_pages" == "true" ]
    then
      echo "- $icon [**$repo**](https://$user.github.io/$repo/)" >> $readme
    else
      echo "- $icon $repo" >> $readme
    fi

    for line in "${descr[@]}"; do
      echo "    - $line" >> $readme
    done

    if [ "$githubio_show_repo" == "true" ]
    then
      echo "    - <https://github.com/$user/$repo>" >> $readme
    fi
  fi
done

cat << EOF >> $readme

#### GitHub Activity

<img src="https://ghchart.rshah.org/jurakovic" alt="GitHub Activity" />

#### Language Stats

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/jurakovic/jurakovic/refs/heads/stats/top-langs-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/jurakovic/jurakovic/refs/heads/stats/top-langs-light.svg">
  <img src="https://raw.githubusercontent.com/jurakovic/jurakovic/refs/heads/stats/top-langs-dark.svg">
</picture>

#### Build Status

[![Update stats](https://github.com/jurakovic/jurakovic/actions/workflows/update-stats.yaml/badge.svg)](https://github.com/jurakovic/jurakovic/actions/workflows/update-stats.yaml)
[![Build Readme](https://github.com/jurakovic/jurakovic.github.io/actions/workflows/build.yaml/badge.svg)](https://github.com/jurakovic/jurakovic.github.io/actions/workflows/build.yaml)
EOF

if [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
  # fix line ending
  dos2unix -q "$readme"
fi

echo "Done"
