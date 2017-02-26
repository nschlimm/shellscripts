#!/bin/sh
# specify keyfunktionsmap=() array and source this script for flex menu capability
# examplecall: menuPunkt a "Push actual (fetch, merge, commit, push)" pushActual.
rawdatafilename=rawdata.txt
summaryfilename=summary.txt
menuitemsfilename=menugroups.txt
rawdatahome=~/Personal/
actualmenu=
waitonexit

function menuInit () {
  touch $rawdatahome$rawdatafilename
  actualmenu="$1"
  menudatamap=()
  export GREP_COLOR='1;37;44'
  echo "$1" | grep --color ".*"
  export GREP_COLOR='01;31'
  echo
}

function submenuHead () {
   actualsubmenuname="$1"
  export GREP_COLOR='1;36'
  echo "$1" | grep --color ".*"
  export GREP_COLOR='01;31'
}

function menuPunkt () {

   menudatamap+=("$1#$2#$3#$actualsubmenuname#$actualmenu")
   echo "$1. $2"

}

function callKeyFunktion () { 
   for i in "${menudatamap[@]}"
     do
       keys=${i:0:1}
         if [ "$1" == "$keys" ]
           then
            clear
            method=$(echo "$i" | cut -f3 -d#)
            if [[ $trackchoices == 1 ]]; then
              logCommand "$1"
            fi
            $method
            echo
            if $waitstatus; then
               read -p $'\n<Press any key to return>' -n 1 -r
             else
              waitonexit # back to default after method execution
            fi
         fi
   done
}

function nowaitonexit () {
  waitstatus=false
}

function waitonexit () {
  waitstatus=true
}

function logCommand () {
   for i in "${menudatamap[@]}"
     do
       keys=${i:0:1}
         if [ "$1" == "$keys" ]
           then
            gkommando=$(echo "$i" | cut -f2 -d#)
            submenuname=$(echo "$i" | cut -f4 -d#)
            method=$(echo "$i" | cut -f3 -d#)
            echo "$actualmenu,$submenuname,$gkommando,$method" >> $rawdatahome$rawdatafilename
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
      kommando=$(echo $kommando | sed 's#/#-#g')
      sed -i.bak "/$kommando/d" $rawdatahome$summaryfilename
      echo "$counta,$menu,$submenu,$kommando,$methode" >> $rawdatahome$summaryfilename
      sort -k1 -nr $rawdatahome$summaryfilename -o $rawdatahome$summaryfilename
      counta=$(grep -c "$submenu" $rawdatahome$rawdatafilename)
      kommando=$(echo $submenu | sed 's#/#-#g')
      sed -i.bak "/$submenu/d" $rawdatahome$menuitemsfilename
      echo "$counta,$menu,$submenu" >> $rawdatahome$menuitemsfilename      
      sort -k1 -nr $rawdatahome$menuitemsfilename -o $rawdatahome$menuitemsfilename
   done < $INPUT
   IFS=$OLDIFS
   importantLog "Your sorted summary of command favorites"
   cat $rawdatahome$summaryfilename
   echo
   importantLog "Your sorted summary of menu favorites"
   cat $rawdatahome$menuitemsfilename 
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
  echo "Select line or nothing to exit drilldown:"
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
  echo "... selected ${fname:-nothing}"
}

function diffDrillDownAdvanced () { # list kommando; regexp to select filename from list command; baseline object name; other object name

  listkommando="$1"
  regexp="$2"

  if $listkommando | grep -q ".*"; then
   while true; do
        
        importantLog "Drill down into file diff: $listkommando"

        selectItem "$listkommando" "$regexp"

        if [[ $fname = "" ]]; then
          break
        fi
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

}

function quit () {
       echo "bye bye, homie!"
       break
}

