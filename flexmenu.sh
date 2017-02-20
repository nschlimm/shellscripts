#!/bin/sh
# specify keyfunktionsmap=() array and source this script for flex menu capability
# examplecall: menuPunkt a "Push actual (fetch, merge, commit, push)" pushActual.

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
            clear
            $method
         fi
   done
}

function importantLog() {
   echo -e -n "\033[1;36m$prompt"
   echo $1
   echo -e -n '\033[0m'
}

function showStatus () {
  importantLog $(pwd | grep -o "[^/]*$")
  actual=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  importantLog $actual 
  git log --decorate --oneline -n 1
  git status | grep "Your branch"
  analyzeWorkingDir
  git remote -v
}

function gentlyCommandNY () {
  
  frage="$1"
  kommando="$2"
  read -p "${frage}" -n 1 -r
  if [[ $REPLY =~ ^[yY]$ ]]
     then
       echo
       executeCommand "$kommando"
     else
      echo 
      echo "Command '$kommando' not executed ..."
  fi      

}


function breakOnNo () {
 read -p "$1" -n 1 -r
 echo
 if [[ $REPLY =~ ^[^Yy]$ ]]; then
   break
 fi
}

function executeCommand () {
 importantLog "Executing: '$1'"
 $1
 importantLog "Finished execution of '$1'"
}

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

function drillDownAdvanced () { # list kommando; regexp to select filename; baseline object name; other object name

  kommando="$1"
  regexp="$2"

   while true; do
     read -p "Continue with drill down into file (y/n)? " -n 1 -r
     echo    # (optional) move to a new line                    if [[ $REPLY =~ ^[Yy]$ ]]
     if [[ $REPLY =~ ^[Yy]$ ]]
     then
        
        $kommando | nl
        echo "Select line:"
        read linenumber
        selected=$($kommando | sed -n ${linenumber}p)

        fname=$(echo $selected | grep -oh "$regexp" | sed "s/ //g")

        echo "... selected $fname"

        if [ $# -eq 3 ]
          then
            executeCommand "git diff $3 $fname"
        fi
        if [ $# -eq 4 ]
          then
            executeCommand "git diff $3:$fname $4:$fname"
        fi

     else
        break
     fi
   done
}

