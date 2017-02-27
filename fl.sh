#!/bin/sh
#!/bin/sh
supergithome=~/Personal
source $supergithome/flexmenu.sh

function expandWorkspace () {
	cd ~/workspaces/carriertech
    selectItem "ls -l | grep -v 'total' | grep -o '[^ ]*$'"
    cd $selected
    nowaitonexit
}

function toDirWorkspace () {
	project="$1"
	eval cd ~/workspaces/carriertech/$project
	nowaitonexit
}

function toDir () {
	eval cd "$1"
	nowaitonexit
}

clear
menuInit "Favorite locations"
submenuHead "Workspace S-Direkt locations"
menuPunkt a "To local workspace carriertech" "toDir ~/workspaces/carriertech"
menuPunkt b "Something in workspace" expandWorkspace
menuPunkt c "To local workspace antragsenden-service" "toDirWorkspace antragsenden-service/"
menuPunkt d "To local workspace bfsach-migration" "toDirWorkspace bfsach-migration/"
menuPunkt e "To local workspace haftpflicht-service" "toDirWorkspace haftpflicht-service/"
menuPunkt f "To local workspace hausrat-service" "toDirWorkspace hausrat-service/"
menuPunkt g "To local workspace historisierung-lib" "toDirWorkspace historisierung-lib/"
echo 
submenuHead "Other favorite locations"
menuPunkt h "To local maven repo root" "toDir ~/.m2/"
menuPunkt i "To local shellscripts" "toDir ~/Personal/"
echo
choice
