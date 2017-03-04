#!/bin/sh
supergithome=~/workspaces/personal/shellscripts
source $supergithome/flexmenu.sh

function toDir () {
	eval cd "$1"
	nowaitonexit
}

clear
thekeys="abcdefghijklmnoprstuvwxyz"
declare -x keycounter=0
menuInit "Favorite locations"
submenuHead "Locations:"
if [ -n ${locations+x} ]; then
	for j in "${locations[@]}"
	do
		locationname=$(echo "$j" | cut -f1 -d'=')
		locationdir=$(echo "$j" | cut -f2 -d'=')
		menuPunkt "${thekeys:${keycounter}:1}" "$locationname" "toDir $locationdir"
       ((keycounter++))
    done
fi
echo
submenuHead "Workspaces:"
if [ -n ${workspaces+x} ]; then
	for j in "${workspaces[@]}"
	do
		locationname=$(echo "$j" | cut -f1 -d'=')
		locationdir=$(echo "$j" | cut -f2 -d'=')
		menuPunkt "${thekeys:${keycounter}:1}" "$locationname" "toDir $locationdir"
        ((keycounter++))
    done
fi
echo
priorlocation=$(pwd) # remember actual location
submenuHead "GIT repos inside workspaces:"
for j in "${workspaces[@]}"
do
	locationdir=$(echo "$j" | cut -f2 -d'=')
	eval cd $locationdir
	lines=$(eval find $locationdir -name ".git")
    while read line; do
    	completelocation=${line::${#line}-5}
    	menuPunkt "${thekeys:${keycounter}:1}" "$completelocation" "toDir $completelocation"
        ((keycounter++))
    done <<< "$(echo -e "$lines")"
done
eval cd "$priorlocation" # return to previous location
echo

coloredLog $(pwd) "1;44"

choice

unset locations workspaces