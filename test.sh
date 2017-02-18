#!/bin/sh
source menu.sh

function drillDown () {
   while true; do
     read -p "Drill down into file (y/n)? " -n 1 -r
     echo    # (optional) move to a new line                    if [[ $REPLY =~ ^[Yy]$ ]]
     if [[ $REPLY =~ ^[Yy]$ ]]
     then
        echo "Enter filename"
        read fname
        if [ $# -eq 1 ]
          then
            git diff $1 $fname
        fi
        if [ $# -eq 2 ]
          then
            git diff $1:$fname $2:$fname
        fi
     else
        break
     fi
   done
}

function importantLog() {
   echo -e -n "\033[1;36m$prompt"
   echo $1
   echo -e -n '\033[0m'
}

function pushActual() {
            git merge origin/$actual
            echo -e -n "\033[1;36m$prompt"
            echo "Status after merge"
            echo -e -n '\033[0m'
            read -p "Commit and push (y/n)? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                   read -p "Enter commit message:" cmsg
                   git add .
                   git commit -m "$cmsg"
                   git push origin $actual
            fi      
}

function mergeActualFromDevBranch() {
            git merge origin/$actual              # to update the state to the latest remote master state
            git branch
            echo "Enter local branch name to merge into actual"
            read localbranchname
            read -p "Merge $localbranchname into $actual (y/n)?" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]
             then
              git merge $localbranchname      # to bring changes to actual from your branch
              echo -e -n "\033[1;36m$prompt"
              echo "Status after merge"
              echo -e -n '\033[0m'
              git status -s
              read -p "Push to remote master (y/n)?" -n 1 -r
              echo
              if [[ $REPLY =~ ^[Yy]$ ]]
                  then
                      echo "Enter commit message"
                      read cmsg
                      git commit -am $cmsg
                      git push 
              fi      
            fi      

}

function mergeActualFromOrigin() {
  git fetch 
  git merge origin/$actual
}

function setUpstream() {
  git fetch 
  git merge origin/$actual
}

function adminRemotes() {
              echo
            echo "Administer remotes:"
            echo "a. Show remotes"
            echo "b. Add remote"
            echo "c. Inspect remote"
            echo
            read -p "Make your choice: " -n 1 -r subreply
            echo

            case $subreply in
                "a")
                   echo $'\nKnown remotes:'
                   git remote -v
                ;;
                "b")
                    echo "What is the adress?"
                    read adress
                    echo "Type an alias for this remote?"
                    read ralias
                    git remote add $ralias $adress
                ;;
                "c")
                    git remote -v
                    echo "Name of the remote to inspect"
                    read rname
                    git remote show $rname
                ;;
            esac

}

function showRepoHisto() {
            git log --pretty=format:'%Cred%h%Creset | %Cgreen%ad%Creset | %s %C(yellow)%d%Creset %C(bold blue)[%an]%Creset %Cgreen(%cr)%Creset' --graph --date=short --all
}

function cloneRemote() {
            echo "Where?"
            . ~/Personal/fl.sh
            echo "Remote repository url:"
            read url
            git clone $url
}

function newLocalBranch() {
              echo "Name des neuen Branch?"
            read branchname
            git branch $branchname 
            git checkout $branchname
            read -p "Set upstream? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                   git push --set-upstream origin $branchname
            fi      
}

function rollBackLast() {
            git reset HEAD~1
            read -p "Override updates in local working dir? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                    git reset HEAD --hard
            fi      
}

function deleteBranch() {
              git branch
            echo "Welchen Branch löschen?"
            read dbranch
            git branch -d $dbranch
            read -p "Delete remote? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                   git push origin --delete $dbranch
            fi 
}

function mergeSourceToTarget(){
              git branch
            echo "Enter merge target branch"
            read target
            echo "Enter merge source branch"
            read bsource
            git checkout $target
            git merge $bsource
}

function showAllBranches () {
              git branch --all
}

function showBranchHisto(){
              git branch 
            echo "Select branch (hit enter for actual):"
            read bname
            if [[ ! -z "$bname" ]]; then
                  git checkout $bname
            fi
            git log --pretty=format:'%Cred%h%Creset | %Cgreen%ad%Creset | %s %C(yellow)%d%Creset %C(bold blue)[%an]%Creset %Cgreen(%cr)%Creset' --graph --date=short
}

function workingDiffs() {
              echo "Everything fetched from remote to local archive."
            echo 
            echo "Working with diffs:"
            echo "a. Show diff between <actual branch> HEAD and <origin/actual branch> HEAD"
            echo "b. Show diff actual working dir vs. HEAD"
            echo "c. Show diff between actual working dir and other commits"
            echo "d. Show diff between two abitrary commits"
            echo "e. Show diff between two abitrary branch HEADs"
            echo "f. Show diff between actual working dir an stage"
            echo "g. Show diff between actual branch and another branch"
            echo "h. Show commits"
            echo
            read -p "Make your choice: " -n 1 -r subreply
            echo

            case $subreply in
                "a")
                    git diff --name-status $actual origin/$actual
                    drillDown $actual origin/$actual
                ;;
                "b")
                    git diff --name-status HEAD
                    drillDown "HEAD"
                ;;
                "f")
                    git diff --name-status
                ;;
                "h")
                    echo "How many commits?"
                    read hmany
                    git log --pretty=format:"%h - %an, %ar : %s" -n $hmany
                ;;
                "c")
                    echo "Last 15 commits"
                    git log --pretty=format:"%h - %an, %ar : %s" -n 15
                    echo "Enter commit name"
                    read cname
                    git diff --name-status $cname
                    drillDown $cname
                ;;
                "d")
                    echo "Last 15 commits"
                    git log --pretty=format:"%h - %an, %ar : %s" -n 15
                    echo "(a) Enter 'baseline' commit name"
                    read cnamea
                    echo "(b) Enter second commit name"
                    read cnameb
                    git diff --name-status $cnamea $cnameb
                    drillDown $cnamea $cnameb
                ;;
                "e")
                    echo "Branches"
                    git branch --all
                    echo "(a) Enter 'branch' name"
                    read cnamea
                    echo "(b) Enter second branch name"
                    read cnameb
                    git diff --name-status $cnamea $cnameb
                    drillDown $cnamea $cnameb
                ;;
                "g")
                    echo "Branches"
                    git branch --all
                    echo "Enter 'branch' name"
                    read cnamea
                    git diff --name-status $actual $cnamea
                    drillDown $actual $cnameb
                ;;
            esac
}

function setUpstream() {
            git push --set-upstream origin $actual
}

function stash() {
            git stash
}

function pop() {
            git stash pop
}

function localGitConfig() {
            vim .git/config
}

function globalGitConfig() {
            vim ~/.gitconfig
}

function adminAliases() {
            echo $'\nActual aliases:'
            git config --get-regexp alias
            read -p "Add or delete aliases (a/d)? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[a]$ ]]
                then
                    echo "Which command?"
                    read bcommand
                    echo "Define alias:"
                    read calias
                    git config --global alias.$calias $bcommand
                    echo "Alias $calias create for $bcommand!"
                else
                    echo "Which alias to delete:"
                    read calias
                    git config --global --unset alias.$calias
            fi      
}

function gitIgnore() {
            vim .gitignore
}

keyfunktionsmap=()

function menuPunkt () {

   keyfunktionsmap+=("$1:$3")
   echo "$1. $2"

}

function callKeyFunktion () { 
   for i in "${keyfunktionsmap[@]}"
     do
       keys=${i:0:1}
         if [ "$1" == "$keys" ]
           then
            method=${i:2}
            $method
         fi
   done
}

function pushActual() {
            git merge origin/$actual
            echo -e -n "\033[1;36m$prompt"
            echo "Status after merge"
            echo -e -n '\033[0m'
            read -p "Commit and push (y/n)? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                   read -p "Enter commit message:" cmsg
                   git add .
                   git commit -m "$cmsg"
                   git push origin $actual
            fi      
}

function makeQuit(){
	return
}

while true; do
echo "Working with remotes:"
menuPunkt a "Push actual (fetch, merge, commit, push)" pushActual
menuPunkt b "Merge actual from actual origin, merge development branch to actual, push actual to origin" mergeActualFromDevBranch
menuPunkt c "Merge actual from actual origin" mergeActualFromOrigin
menuPunkt e "Set upstream to actual" setUpstream
menuPunkt g "Administer remotes" adminRemotes
menuPunkt h "Interactive push" interactivePush
menuPunkt i "Show repository history" showRepoHisto
menuPunkt j "Clone remote repository" cloneRemote
echo
echo "Working on local branches"
menuPunkt k "New local branch, checkout (branch, checkout, optional: push set-upstream)" newLocalBranch
menuPunkt l "Rollback gently head to last commit" rollBackLast
menuPunkt n "Delete local branch" deleteBranch
menuPunkt o "Merge from source branch to target branch" mergeSourceToTarget
menuPunkt p "Show all branches (incl. remote)" showAllBranches
menuPunkt r "Show branch history" showBranchHisto
menuPunkt f "Working with diffs" workingDiffs
echo
echo "Other usefull actions:"
menuPunkt u "Stash: save local changes and bring head to working dir" stash
menuPunkt v "Stash pop: revert last stash" pop
echo
echo "Git admin actions"
menuPunkt 1 "Show local git config" localGitConfig
menuPunkt 2 "Show global git config" globalGitConfig
menuPunkt 3 "Administering aliases" adminAliases
menuPunkt 4 "Show .gitignore" gitIgnore
echo
echo "Press 'q' to quit"
echo
echo "[Ctrl]+P Change project"
echo "[Ctrl]+B Change branch"
echo "[Ctrl]+F Fetch all remotes"
echo
git fetch --all 2> /dev/null
importantLog $(pwd | grep -o "[^/]*$")
actual=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
importantLog $actual 
git log --decorate --oneline -n 1
git status | grep "Your branch"
wstat=$(git diff --shortstat)
if [ -z "$wstat" ]; then
    wstat="clean"
fi
echo "Working directory vs. actual checkout: $wstat"
echo
git remote -v
git remote show origin | grep "  $actual"

echo
read -p "Make your choice: " -n 1 -r
echo

callKeyFunktion $REPLY

case $REPLY in
	    $'\x10')
            . ~/Personal/fl.sh
        ;;
        $'\x02')
            git branch --all
            echo "Which branch?"
            read bname
            git checkout $bname
        ;;
        $'\x06')
            git fetch --all
        ;;
        "q")
			break
			;;
esac
echo
read -p $'\n<Press any key to return>' -n 1 -r
done