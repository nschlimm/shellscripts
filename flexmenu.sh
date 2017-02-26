#!/bin/sh
# specify keyfunktionsmap=() array and source this script for flex menu capability
# examplecall: menuPunkt a "Push actual (fetch, merge, commit, push)" pushActual.
rawdatafilename=rawdata.txt
summaryfilename=summary.txt
menuitemsfilename=menugroups.txt
rawdatahome=~/Personal/
actualmenu=

function menuInit () {
  touch $rawdatahome$rawdatafilename
  actualmenu="$1"
  keyfunktionsmap=()
  keymenuitemmap=()
  keysubmenumap=()
  menudatamap=()
  export GREP_COLOR='1;37;41'
  echo "$1" | grep --color ".*"
  export GREP_COLOR='01;31'
}

function submenuHead () {
   actualsubmenuname="$1"
   echo "$1"
}

function menuPunkt () {

   keyfunktionsmap+=("$1:$3")
   keymenuitemmap+=("$1:$2")
   keysubmenumap+=("$1:$actualsubmenuname")
   menudatamap+=("$1#$2#$actualsubmenuname#$actualmenu")
   echo "$1. $2"

}

function callKeyFunktion () { 
   for i in "${keyfunktionsmap[@]}"
     do
       keys=${i:0:1}
         if [ "$1" == "$keys" ]
           then
            clear
            method=${i:2}
            if [[ $trackchoices == 1 ]]; then
              logCommand "$1" "$method"
            fi
            $method
         fi
   done
}

function logCommand () {
  method="$2"
   for i in "${keymenuitemmap[@]}"
     do
       keys=${i:0:1}
         if [ "$1" == "$keys" ]
           then
            gkommando=${i:2}
            findSubmenuname "$1"
            echo "$actualmenu,$submenuname,$gkommando,$method" >> $rawdatahome$rawdatafilename
         fi
   done
}

function findSubmenuname () {
  keypressed="$1"
   for i in "${keysubmenumap[@]}"
     do
       keys=${i:0:1}
         if [ "$keys" == "$keypressed" ]
           then
            submenuname=${i:2}
         fi
   done
}

function compileMenu () {
   touch $rawdatahome$summaryfilename
   touch $rawdatahome$menuitemsfilename
   INPUT=$rawdatahome$rawdatafilename
   OLDIFS=$IFS
   IFS=,
   [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
   while read menu submenu kommando methode
   do
      counta=$(grep -c "$kommando" $rawdatahome$rawdatafilename)
      sed -i.bak "/$kommando/d" $rawdatahome$summaryfilename
      echo "$counta,$menu,$submenu,$kommando,$methode" >> $rawdatahome$summaryfilename
      sort -k1 -nr $rawdatahome$summaryfilename -o $rawdatahome$summaryfilename
      counta=$(grep -c "$submenu" $rawdatahome$rawdatafilename)
      sed -i.bak "/$submenu/d" $rawdatahome$menuitemsfilename
      echo "$counta,$menu,$submenu" >> $rawdatahome$menuitemsfilename      
      sort -k1 -nr $rawdatahome$menuitemsfilename -o $rawdatahome$menuitemsfilename
   done < $INPUT
   IFS=$OLDIFS
}

function purgeCash () {
  rm $rawdatahome$summaryfilename
  rm $rawdatahome$menuitemsfilename
  rm $rawdatahome$rawdatafilename
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
 eval $1
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
            git diff --color $1 $fname | diff-so-fancy
        fi
        if [ $# -eq 2 ]
          then
            git diff --color $1:$fname $2:$fname | diff-so-fancy
        fi
     else
        break
     fi
   done
}

function selectItem () {
  listkommando="$1"
  regexp="$2"
  eval $listkommando | nl -n 'ln' -s " "
  echo "Select line or 'q' to exit drilldown:"
  read linenumber
  if [ "$linenumber" = "q" ]; then
    break
  fi
  if [ -z "$linenumber" ]; then
     selected=""
   else
     selected=$($listkommando | sed -n ${linenumber}p)
  fi
  fname=$(echo $selected | grep -oh "$regexp" | sed "s/ //g")
  echo "... selected $fname"
}

function diffDrillDownAdvanced () { # list kommando; regexp to select filename from list command; baseline object name; other object name

  listkommando="$1"
  regexp="$2"

  if $listkommando | grep -q ".*"; then
   while true; do
        
        importantLog "Drill down into file diff: $listkommando"

        selectItem "$listkommando" "$regexp"

        if [ $# -eq 3 ]
          then
             kommando="git diff --color $3 $fname | diff-so-fancy"
             executeCommand "$kommando"
        fi
        if [ $# -eq 4 ]
          then
             kommando="git diff --color $3 $4 $fname | diff-so-fancy"
             executeCommand "$kommando"
        fi

        read -p $'\n<Press any key to return>' -n 1 -r
        if [ "$REPLY" = "c" ]; then
           clear
        fi        

   done

  fi

}

function choice () {
  echo
  echo "Press 'q' to quit"
  echo
  read -p "Make your choice: " -n 1 -r
  echo

  case $REPLY in 
    "q" )
       echo "bye, bye, homie!"
       break
      ;;
  esac
  
  callKeyFunktion $REPLY

  echo
  read -p $'\n<Press any key to return>' -n 1 -r
}

function quit () {
       echo "bye bye, homie!"
       break
}

