#!/bin/sh
supergithome=~/Personal
source $supergithome/flexmenu.sh

function analyzeWorkingDir (){
   wstat=$(git diff HEAD --shortstat) # analyze local dir working status vs. actual checkout
   if [ -z "$wstat" ]; then
      wstat="clean"
   fi
   echo "Working directory vs. HEAD: $wstat"
   echo
}

function pushActual() {
  importantLog "Checking your head state"
  if git status | grep -q "HEAD detached"; then
     echo "... you seem to be on a detached head state ... can't push ..."
  else
    echo "... your HEAD is attached to $actual ..."
    importantLog "Checking for updates from origin/$actual"
    if git diff $actual origin/$actual | grep -q ".*"; then
       echo "... found updates in origin/$actual ..."
       git diff --name-status $actual origin/actual
       read -p "Merge (y/n)? " -n 1 -r
       echo    # (optional) move to a new line
       if [[ $REPLY =~ ^[Yy]$ ]]; then
          git merge origin/$actual
       fi
    else
       echo "... nothing to merge ... up to date"
    fi
    importantLog "Checking for stuff to commit and push in working tree"
    if git diff HEAD --name-status | grep -q ".*"; then
      echo "... found updates in working tree ..."
      git diff HEAD --name-status
      read -p "Commit and push those updates (y/n)? " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
           read -p "Enter commit message:" cmsg
           git commit -am "$cmsg"
           git push origin $actual
      fi
    else
      echo "... nothing to commit ..."
    fi
  fi
}

function mergeActualFromOrigin() {
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
            pwd
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
  . $supergithome/diff.sh
}

function setUpstream() {
   git branch --set-upstream-to=origin/$actual
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

function makeQuit(){
    return
}

function undoReset () {
  git reflog
  echo "Choose commit to reset:"
  read cname
  if [ -z "$cname" ]; then
    echo "No commit entered!"
  else
    git reset $cname
  fi
}

function interactiveStage () {
   git add -i
}

git fetch --all 2> /dev/null

while true; do
clear
keyfunktionsmap=()
echo "Working with remotes:"
menuPunkt a "Gently push actual" pushActual
menuPunkt c "Merge actual from actual origin" mergeActualFromOrigin
menuPunkt d "Clone remote repository" cloneRemote
menuPunkt e "Set upstream to actual" setUpstream
menuPunkt f "Administer remotes" adminRemotes
menuPunkt g "Show repository history" showRepoHisto
echo
echo "Working on local branches:"
menuPunkt k "New local branch, checkout" newLocalBranch
menuPunkt n "Delete local branch" deleteBranch
menuPunkt o "Merge from source branch to target branch" mergeSourceToTarget
menuPunkt p "Show all branches (incl. remote)" showAllBranches
menuPunkt r "Show branch history" showBranchHisto
echo
echo "Navigating around commits:"
menuPunkt l "Rollback head to last commit" rollBackLast
menuPunkt m "Undo reset commands" undoReset
menuPunkt s "Working with diffs" workingDiffs
echo
echo "Other usefull actions:"
menuPunkt t "Interactively staging files" interactiveStage
menuPunkt u "Stash: save local changes and bring head to working dir" stash
menuPunkt v "Stash pop: revert last stash" pop
echo
echo "Git admin actions:"
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
importantLog $(pwd | grep -o "[^/]*$")
actual=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
importantLog $actual 
git log --decorate --oneline -n 1
git status | grep "Your branch"
analyzeWorkingDir
git remote -v

echo
read -p "Make your choice: " -n 1 -r
echo

callKeyFunktion $REPLY

# CTRL-Key commands
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
       echo "bye bye, homie!"
       break
    ;;
esac

echo
read -p $'\n<Press any key to return>' -n 1 -r
done