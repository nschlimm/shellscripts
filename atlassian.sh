#!/bin/sh
supergithome=~/Personal
source flexmenu.sh

function settingUp () {
	source $supergithome/atSettingUp.sh
}

git fetch --all

while true; do
clear
keyfunktionsmap=()

echo "Atlassian's View"
echo "Atlassians view on GIT, https://de.atlassian.com/git/tutorials"
echo 
echo "Working on your local repository"
menuPunkt a "Setting up a repository" settingUp
menuPunkt b "Saving changes" 
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
echo
echo "Press 'q' to quit"
echo
#echo "[Ctrl]+P <some stuff>"
#echo "[Ctrl]+B <some action>"
#echo "[Ctrl]+F <another action>"
#echo
read -p "Make your choice: " -n 1 -r choice

case $choice in
#    $'\x10')
#       . ~/Personal/fl.sh
#    ;;
#    $'\x02')
#       git branch --all
#       echo "Which branch?"
#       read bname
#       git checkout 
#    ;;
#    $'\x06')
#       git fetch --all
#    ;;
    "q")
       break
    ;;
esac
(callKeyFunktion $choice)
read -p $'\n<Press any key to return>' -n 1 -r
done