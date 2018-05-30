#!/bin/bash

find ../apostilas-novas -type d -maxdepth 1  > diretorios_completos.txt

DIRETORIOS=""
while read -r dir
do
	current=${dir#"../apostilas-novas/"}
	if [[ $current =~ [a-zA-Z][a-zA-Z]-[0-9][0-9] ]]; then
    DIRETORIOS+="$current/ "
	fi
done < "diretorios_completos.txt"


git clone --no-hardlinks ../apostilas-novas ./apostilas-novas-limpo

cd apostilas-novas-limpo/
git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch $DIRETORIOS" HEAD

git reset --hard
git gc --aggressive
git prune
git remote rm origin

base_url='https://gitlab.com/aovs/apostilas'
git push -u  $base_url/apostilas.git master

