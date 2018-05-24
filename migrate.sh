#!/bin/bash


workdir=$(pwd)

usuario=caelum
find ../apostilas-novas -path "*" -type d -depth 1  > diretorios_completos.txt

while read -r dir
do
	current=${dir#"../apostilas-novas/"}
	if [[ $current =~ [a-zA-Z][a-zA-Z]-[0-9][0-9] ]]; then
		echo "$current" >> diretorios.txt
	fi
done < "diretorios_completos.txt"

while read -r current
do
		echo $current
	  mkdir $current
		
		git clone --no-hardlinks ../apostilas-novas ./$current
		
		cd $current

		git filter-branch --subdirectory-filter $current HEAD -- --all
		git reset --hard
		git gc --aggressive
		git prune
		git remote rm origin

		git remote add origin https://gitlab.com/$usuario/$current.git

		cd $workdir
	
done < "diretorios.txt"
