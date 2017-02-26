#!/bin/sh
supergithome=~/Personal
source flexmenu.sh

function numberedList () {
  kommando="$1"

}

function headHead () {
   importantLog "Comparing $actual HEAD to $actual/origin HEAD"
   diffDrillDownAdvanced "git diff --name-status $actual origin/$actual" "[ ].*$" "$actual" "origin/$actual"
}

function dirHead () {
   importantLog "Comparing working tree to HEAD"
   diffDrillDownAdvanced "git diff --color --name-status HEAD" "[ ].*$" "HEAD"
}

function treeCommit () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 15
   echo "Enter commit name"
   read cname
   diffDrillDownAdvanced "git diff --name-status $cname" "[ ].*$" "$cname"
}

function treeStage () {
   commit=$(git show --oneline -s | grep -o "[a-z0-9]*")
   diffDrillDownAdvanced "git diff --name-status $commit" "[ ].*$" "$commit"	
}

function commitCommit () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 15
   echo "(a) Enter 'baseline' commit name"
   read cnamea
   echo "(b) Enter second commit name"
   read cnameb
   diffDrillDownAdvanced "git diff --name-status $cnamea $cnameb" "[ ].*$" "$cnamea" "$cnameb"
}

function branchBranch () {
   echo "Branches"
   git branch --all
   echo "(a) Enter 'branch' name"
   read cnamea
   echo "(b) Enter second branch name"
   read cnameb
   diffDrillDownAdvanced "git diff --name-status $cnamea $cnameb" "[ ].*$" "$cnamea" "$cnameb"	
}

function actualHeadbranchHead () {
    echo "Branches"
    git branch --all
    echo "Enter 'branch' name"
    read cnamea
    diffDrillDownAdvanced "git diff --name-status $actual $cnamea" "[ ].*$" "$actual" "$cnamea"  
}

function showCommits () {
    echo "How many commits?"
    read hmany
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n $hmany
}

git fetch --all

while true; do
clear
menuInit "Working with diffs"
echo "Note: GIT diff cann compare three locations with each other: the tree (your working directory), the stage, the repository."
submenuHead "Different diff options:"
menuPunkt a "actual HEAD vs. origin/actual branch HEAD  -> repository vs. repository" headHead
menuPunkt b "actual working dir   vs. HEAD              -> tree vs. repository" dirHead
menuPunkt c "actual working dir   vs. other commits     -> tree vs. repository" treeCommit
menuPunkt d "actual working dir   vs. stage             -> tree vs. index" treeStage
menuPunkt e "commit               vs. commit            -> repository vs. repository" commitCommit
menuPunkt f "branch head          vs. branch head       -> repository vs. repository" branchBranch
menuPunkt g "actual branch head   vs. branch head       -> repository vs. repositoty" actualHeadbranchHead
menuPunkt h "show commits" showCommits
menuPunkt q "quit" quit
echo
choice
done