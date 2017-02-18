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

