#!/bin/sh
supergithome=~/Personal
source flexmenu.sh

# all your menu actions here

git fetch --all

while true; do
clear
keyfunktionsmap=()

echo "Saving changes"
menuPunkt a "actual HEAD vs. origin/actual branch HEAD  -> repository vs. repository" headHead
menuPunkt b "actual working dir   vs. HEAD              -> tree vs. repository" dirHead
echo
showStatus
choice
done
