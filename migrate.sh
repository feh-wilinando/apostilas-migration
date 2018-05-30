#!/bin/bash

read -p "Digite o usuario:" -s user
read -p "Digite a senha:" -s pass
workdir=$(pwd)

base_url='gitlab.com/aovs/apostilas'
find ../apostilas-novas -maxdepth 1 -type d > diretorios_completos.txt

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

		git push -u  https://$user:$pass@$base_url/$current.git master

		cd $workdir
	
done < "diretorios.txt"
