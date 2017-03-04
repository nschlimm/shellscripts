#!/bin/sh
supergithome=~/workspaces/personal/shellscripts
source $supergithome/flexmenu.sh

function toDir () {
	currentdir="$1"
	nowaitonexit
}

while true; do
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
echo

eval cd $currentdir # set the directory in the current shell

coloredLog $(pwd) "1;44"

choice

done

unset locations workspaces