#!/bin/sh
supergithome=~/Personal
source flexmenu.sh

function numberedList () {
  kommando="$1"

}

function headHead () {
   git diff --name-status $actual origin/$actual
   drillDown $actual origin/$actual
}

function dirHead () {
   importantLog "Comparing working tree to HEAD"
   git diff --name-status HEAD
   drillDownAdvanced "git diff --name-status HEAD" "[ ].*$" "HEAD"
}

function treeCommit () {
   echo "Last 15 commits"
   git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 15
   echo "Enter commit name"
   read cname
   git diff --name-status $cname
   drillDown $cname

}

function treeStage () {
   git diff --name-status  
   commit=$(git show --oneline -s | grep -o ".* ")
   drillDown $commit
	
}

function commitCommit () {
   echo "Last 15 commits"
   git log --pretty=format:"%h - %an, %ar : %s" -n 15
   echo "(a) Enter 'baseline' commit name"
   read cnamea
   echo "(b) Enter second commit name"
   read cnameb
   git diff --name-status $cnamea $cnameb
   drillDown $cnamea $cnameb
	
}

function branchBranch () {
   echo "Branches"
   git branch --all
   echo "(a) Enter 'branch' name"
   read cnamea
   echo "(b) Enter second branch name"
   read cnameb
   git diff --name-status $cnamea $cnameb
   drillDown $cnamea $cnameb
	
}

function actualHeadbranchHead () {
    echo "Branches"
    git branch --all
    echo "Enter 'branch' name"
    read cnamea
    git diff --name-status $actual $cnamea
    drillDown $actual $cnameb
	
}

function showCommits () {
    echo "How many commits?"
    read hmany
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n $hmany
	
}

git fetch --all

while true; do
clear
keyfunktionsmap=()

echo "Note: GIT diff cann compare three locations with each other: the tree (your working directory), the stage, the repository."
echo "Working with diffs:"
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