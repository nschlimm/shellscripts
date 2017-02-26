#!/bin/sh
supergithome=~/Personal
source flexmenu.sh

function settingUp () {
	source $supergithome/atSettingUp.sh
}

function savingChanges () {
	source $supergithome/atSaveChanges.sh
}

git fetch --all

while true; do
clear
menuInit "Atlassian's View"
echo "Atlassians view on GIT, https://de.atlassian.com/git/tutorials"
echo 
echo "Working on your local repository"
menuPunkt a "Setting up a repository" settingUp
menuPunkt b "Saving changes" savingChanges
menuPunkt c "Inspecting a repository" 
menuPunkt d "Undoing changes" 
menuPunkt e "Rewriting history" 
echo
echo "Collaborating with your homies"
menuPunkt i "Syncing" 
menuPunkt k "Making a pull request" 
menuPunkt l "Using branches" 
echo
echo "Advanced stuff"
menuPunkt n "Merging vs. Rebasing" 
menuPunkt o "Reset, checkout and revert" 
menuPunkt p "Advanced Git log" 
menuPunkt q "Git Hooks" 
menuPunkt r "Refs and the Reflog" 
menuPunkt s "Git LFS" 
echo
showStatus
choice
done
