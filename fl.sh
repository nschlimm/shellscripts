#!/bin/sh
supergithome=~/workspaces/personal/shellscripts
source $supergithome/flexmenu.sh

function toDir () {
	eval cd "$1"
	nowaitonexit
}

function purgDirCache () {
	unset gitlocations
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
uncached=false
priorlocation=$(pwd) # remember actual location
if [ -z ${gitlocations+x} ]; then
   uncached=true
   declare -a gitlocations
   index=0
   for j in "${workspaces[@]}"
   do
   	  locationdir=$(echo "$j" | cut -f2 -d'=')
   	  eval cd $locationdir
   	  lines=$(eval find $locationdir -name ".git")
      while read line; do
       	completelocation=${line::${#line}-5}
       	gitlocations[$index]="${thekeys:${keycounter}:1} $completelocation toDir $completelocation"
        ((keycounter++))
        ((index++))
      done <<< "$(echo -e "$lines")"
   done
fi
eval cd "$priorlocation" # return to previous location
# prin out git location cache
submenuHead "GIT repos inside workspaces:"
for (( i = 0; i < ${#gitlocations[@]}; i++ )); do
    arrIN=(${gitlocations[$i]})
	menuPunkt "${arrIN[0]}" "${arrIN[1]}" "${arrIN[2]} ${arrIN[3]}" 
done
if $uncached; then coloredLog "NEW" "1;42"; else coloredLog "CACHED" "1;42"; fi
echo
submenuHead "Shortcuts"
menuPunkt X "Purge git dir cache" purgDirCache
echo
coloredLog $(pwd) "1;44"

choice

unset locations workspaces