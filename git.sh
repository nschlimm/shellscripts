#!/bin/sh

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

while true; do
clear
echo "Working with remotes:"
echo "a. Push actual (fetch, merge, commit, push)"
echo "b. Merge actual from actual origin, merge development branch to actual, push actual to origin"
echo "c. Merge actual from actual origin"
echo "e. Set upstream to actual"
echo "g. Administer remotes"
echo "h. Interactive push"
echo "i. Show repository history"
echo "j. Clone remote repository"
echo
echo "Working on local branches:"
echo "k. New local branch, checkout (branch, checkout, optional: push set-upstream)"
echo "l. Rollback head to last commit"
echo "m. Override working dir with head (you loose the changes!)"
echo "n. Delete local branch"
echo "o. Merge from source branch to target branch"
echo "p. Show all branches (incl. remote)"
echo "r. Show branch history"
echo "f. Working with diffs"
echo
echo "Other usefull actions:"
echo "u. Stash: save local changes and bring head to working dir"
echo "v. Stash pop: revert last stash"
echo
echo "Git admin actions:"
echo "1. Show local git config"
echo "2. Show global git config"
echo "3. Administering aliases"
echo "4. Show .gitignore"
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

#COLUMNS=100
#PS3='Please enter your choice: '
#select choice in  \
#    "Historie des aktuellen branch anzeigen" \
#    "Historie des repositories anzeigen lassen" \
#    "Alle Branches anzeigen lassen (auch von remote)" \
#    "Quit"
#do
    case $REPLY in
#    case $choice in
        "a")
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

        ;;
        "k")
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

        ;;
        "b")
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


        ;;
        "e")
            git push --set-upstream origin $actual
        ;;
        "f")
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

        ;;
        "l")
            git reset HEAD~1
            read -p "Override updates in local working dir? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                    git reset HEAD --hard
            fi      

        ;;
        "m")
            read -p "Override updates in local working dir? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                   git reset HEAD --hard
            fi      

        ;;
        "u")
            git stash

        ;;
        "v")
            git stash pop

        ;;
        "c")
            git fetch
            git merge origin/$actual

        ;;
        "1")
            vim .git/config

        ;;
        "2")
            vim ~/.gitconfig

        ;;
        "4")
            vim .gitignore

        ;;
        "n")
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

        ;;
        "3")
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

        ;;
        "o")
            git branch
            echo "Enter merge target branch"
            read target
            echo "Enter merge source branch"
            read bsource
            git checkout $target
            git merge $bsource

        ;;
        "g")
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

        ;;
        "i")
            echo "What is the remote name?"
            read rname
            git branch
            echo "What branch do you wish to push?"
            read brname
            git push $rname $brname

        ;;
        "r")
            git branch 
            echo "Select branch (hit enter for actual):"
            read bname
            if [[ ! -z "$bname" ]]; then
                  git checkout $bname
            fi
            git log --pretty=format:'%Cred%h%Creset | %Cgreen%ad%Creset | %s %C(yellow)%d%Creset %C(bold blue)[%an]%Creset %Cgreen(%cr)%Creset' --graph --date=short

        ;;
        "h")
            git log --pretty=format:'%Cred%h%Creset | %Cgreen%ad%Creset | %s %C(yellow)%d%Creset %C(bold blue)[%an]%Creset %Cgreen(%cr)%Creset' --graph --date=short --all

        ;;
        "p")
            git branch --all

        ;;
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
        "j")
            echo "Where?"
            . ~/Personal/fl.sh
            echo "Remote repository url:"
            read url
            git clone $url
         
        ;;
        "q")
            echo $'\nbye bye\n'
            break

        ;;

    esac
    echo
    read -p $'\n<Press any key to return>' -n 1 -r
done

