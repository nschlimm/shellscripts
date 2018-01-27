#!/bin/bash
echo "User name?"
read username
echo "Password?"
read neuespasswort
echo "Absoluter Pfad Workspace?"
read workspacedir
cd $workspacedir
array=($(ls -d */))
for i in "${array[@]}"
do
	echo $i
	cd $i
	git remote set-url origin https://$username:$neuespasswort@git-ext.provinzial.com/sdirekt/${i%?}.git/
	cd ..
done