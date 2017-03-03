#!/bin/sh
supergithome=~/Personal
source $supergithome/flexmenu.sh

# all your menu actions here

function changeBlame () {
	git log --pretty=format:'%Cred%h%Creset | %Cgreen%ad%Creset | %s %C(yellow)%d%Creset %C(bold blue)[%an]%Creset %Cgreen(%cr)%Creset' --graph --date=short
	echo "Enter baseline commit:"
	read baseline
	echo "Enter until commit (default HEAD):"
	read untilcommit
	executeCommand "git guilt $baseline ${untilcommit:-HEAD}"
}

function removeLatest () {
	echo "How many commits to remove?"
	read ccommit
	executeCommand "git back $ccommit"
}

while true; do
clear
menuInit "Git extras menu"
submenuHead "Project information"
menuPunkt a "Project summary in commits" "git summary"
menuPunkt b "Project summary in lines of code" "git summary --line"
menuPunkt c "Effort in the project per file" "git effort"
menuPunkt d "Show all ignore patterns from local and global" "git ignore"
menuPunkt e "Show information about the repo" "git info"
menuPunkt f "Display change in blame between two revisions" changeBlame
menuPunkt g "List authors" "git authors --list"
menuPunkt h "Remove latest commits and add their changes to stage" removeLatest
menuPunkt i "Generate changelog" "git changelog -a"
echo
choice
done
