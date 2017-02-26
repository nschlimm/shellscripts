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
  executeCommand "git commit -a"
}

function interactiveStage () {
   executeCommand "git add -i"
}

function commitStagedSnapshot () {
	executeCommand "git commit"
}

git fetch --all

while true; do
clear
menuInit "Saving changes"
submenuHead "Adding changes to stage:"
menuPunkt a "Git add all gently" addAllGently
menuPunkt b "Git interactive staging session" interactiveStage
menuPunkt c "Git interactive staging detail session" interStage
echo
submenuHead "Commit changes:"
menuPunkt d "Commit staged snapshot - vim (stage -> archive)" commitStagedSnapshot
menuPunkt e "Commit staged snapshot - read (stage -> archive)" 
menuPunkt f "Commit all changes to tracked files - vim (tree -> stage -> archive)"
menuPunkt g "Commit all changes to tracked files - read (tree -> stage -> archive)"
echo
showStatus
choice
done
