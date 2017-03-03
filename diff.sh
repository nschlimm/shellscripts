#!/bin/sh
supergithome=~/Personal
source $supergithome/flexmenu.sh

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
    git log --graph --pretty=format:'%Cred%h%Creset %ad: %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n ${hmany:-100} --date=short
}

function diffDate () {
   echo "Enter date since in [yyyy-mm-dd]:"
   read sincedate
   lastcommitdate=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" --since "$sincedate 00:00:00" | cut -f3 -d' ' | tail -1) # the last commit date since the date given
   echo "last date: $lastcommitdate"
   commitpriortolast=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" | grep "$lastcommitdate" -A 1 | tail -1 | cut -f2 -d' ') # commit before the last commit in period
   commitdatepriortolast=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" | grep "$lastcommitdate" -A 1 | tail -1 | cut -f3 -d' ') # commit date before the last commit in period
   echo "commit prior to last date: $commitpriortolast ... on: $commitdatepriortolast"
   newestcommit=$(git log --pretty=format:'%h %ad' --graph --date=format:"%Y-%m-%d" | head -1 | cut -f2 -d' ')
   echo "latest commit: $newestcommit"
   diffDrillDownAdvanced "git diff --name-status $commitpriortolast $newestcommit" "[ ].*$" "$commitpriortolast" "$newestcommit"
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
echo
submenuHead "Specific diffs:"
menuPunkt k "Diff since date" diffDate
echo
submenuHead "Other usefull stuff here:"
menuPunkt h "show commits" showCommits
menuPunkt q "quit" quit
echo
choice
done