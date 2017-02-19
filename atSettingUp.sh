#!/bin/sh
supergithome=~/Personal
source flexmenu.sh

function atLocalGit () {

	pwd
	gentlyCommandNY "Do you want to create a repository in current directory (y/n)?" "git init"

}

function atLocalGitWithDir () {
	pwd
	echo "Enter the target directory (absolute or relative position):"
	read directory
	start=${directory:0:1}
	if [ "$start" == "/" ]; then
		breakOnNo "You entered an absolut path, continue? (y/n)? "
    fi
    gentlyCommandNY "Do you want to create a directory and repository in ${directory} (y/n)?" "git init $directory"
}

while true; do
clear
keyfunktionsmap=()

echo "Setting up repositories"
menuPunkt a "Transform the current directory into a git repository" atLocalGit
menuPunkt b "Setting up a git repository in a directory" atLocalGitWithDir
echo
echo "Press 'q' to quit"
echo
read -p "Make your choice: " -n 1 -r choice
echo
case $choice in
    "q")
       break
    ;;
esac
(callKeyFunktion $choice)
read -p $'\n<Press any key to return>' -n 1 -r
done
