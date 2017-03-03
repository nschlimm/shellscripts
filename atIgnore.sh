#!/bin/sh
supergithome=~/Personal
source /flexmenu.sh

# all your menu actions here

while true; do
clear
menuInit "Ignore menu"
submenuHead "Ignoring files:"
menuPunkt y "Adding shared ignore rules (.gitignore)" sharedIgnoreRules
menuPunkt z	"Adding personal git ignore rules (.git/info/exclude)" personalIgnoreRules
menuPunkt 1	"Adding global git ignore rules (~/.gitignore)" globalIgnoreRules
menuPunkt 2	"Ignoring a previously commited file" ignorePrevCommited
menuPunkt 3 "Committing an ignored file" commitIgnored
menuPunkt 4 "Defining exceptions to ignore rules (.gitignore)" defineIgnoreException
menuPunkt 5 "Stashing an ignored file" stashIgnored
echo
showStatus
choice
done
