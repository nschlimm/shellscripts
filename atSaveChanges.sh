#!/bin/sh
supergithome=~/Personal
source flexmenu.sh

function interStage () {
	git add -p
}

function addAllGently () {
  if git ls-files --others --exclude-standard | grep -q ".*"; then
     echo "... untracked files found ..."
     git ls-files --others --exclude-standard
     read -p "Add all (y/n)? " -n 1 -r
     echo    # (optional) move to a new line
     if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
     fi
  fi
}

function commitAllChanges () {
  git commit -a 
}

git fetch --all

while true; do
clear
keyfunktionsmap=()

echo "Saving changes"
menuPunkt a "Git add all gently" addAllGently
menuPunkt b "Git interactive staging detail session" interStage
menuPunkt c "Gently commit a snapshot of all changes in the working directory" commitAllChanges
echo
showStatus
choice
done
