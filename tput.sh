#!/bin/sh
clear
i=0

files=( $(ls) )
while read lsline; do
  filesarray[i]="$lsline"
  ((i++))
done <<< "$(echo -e "$files")"

ls -l
tput sc
tput home
down=$(( ${#filesarray[@]} + 1 ))
while [[ $direction != "q" ]]; do
read -p "" -n 1 -r -s direction
if [[ $direction == "n" ]]; then
	((cursorindex++))
	tput cup $cursorindex 0
fi
if [[ $direction == "j" ]]; then
	((cursorindex--))
	tput cup $cursorindex 0
fi
if [[ $direction == "" ]]; then
    tput cup $down 0
	less -d10 "${files[$cursorindex]}"
	tput cup $cursorindex 0
fi
done
tput rc