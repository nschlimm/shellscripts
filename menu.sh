#!/bin/sh
function substring() { # $1: string $2: fromindex $3: toindex
  eval thestring="$1"
  eval from="$2"
  eval to="$3"
  echo ${thestring:from:$((to-from))}
}

function importantLog() {
   echo -e -n "\033[1;36m$prompt"
   echo $1
   echo -e -n '\033[0m'
}

function getMenuName () { # $1 in format i.e. 00:Puching:

    eval menuname="$1"
    echo ${menuname:3}

}

function getMenuFunktionsName () { # $1 in Format i.e. 00:Push master (checkout, fetch, merge, push)#pushMaster

  eval untermenustr="$1"
  indexs=$(echo $untermenustr | sed -n "s/[#].*//p" | wc -c)
  methodname=${untermenustr:indexs}
  echo $methodname

}

function getUntermenuName () { # $1 in Format i.e. 00:Push master (checkout, fetch, merge, push)#pushMaster

    eval untermenustr="$1"
    indexs=$(echo $untermenustr | sed -n "s/[#].*//p" | wc -c)
    themenuitemtext=$(substring "{$1}" 4 $indexs)
    echo $themenuitemtext

}

function getKeyForAction () {

    eval aktionstr="$1"
    echo $aktionstr | grep -oh ":\w" | cut -c 2-2

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

function erstelleMenu(){
   keyfunktionsmap=()
   counter=0
   for i in "${menus[@]}"
   do
       echo $(getMenuName "\${menus[$counter]}")
       menuindex=${i:0:2}
       acounter=0
       for j in "${menuitems[@]}"
       do
          untermenuindex=${j:0:2}
          if [ "$untermenuindex" -eq "$menuindex" ]
           then
              key=$(echo $(getKeyForAction "\${menuitems[$acounter]}"))
              funktion=$(echo $(getMenuFunktionsName "\${menuitems[$acounter]}"))
              keyfunktionsmap+=("$key:$funktion")
              echo $(getUntermenuName "\${menuitems[$acounter]}")
          fi
          ((acounter++))
       done
       ((counter++))
       echo
   done
}