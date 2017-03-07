#!/bin/sh
invers=`tput rev`
reset=`tput sgr0`
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red

#
# print usage message
#
usage() {
  echo 1>&2 "usage: git bulk --workspace [(--add | --remove) <ws-name> <ws-root-directory> | --purge]"
  echo 1>&2 "       git bulk --listall"
  echo 1>&2 "       git bulk [-g] <git command>"
}

# add another workspace to global ggit config
function addWSDir () {
	git config --global bulkworkspaces.$wsname "$wsdir"
}

# list all current workspace locations defined
function listWSDir () {
	git config --global --get-regexp bulkworkspaces
}

# atomic execution of a git command in one specific repository
function guardedExecution () {
   if [[ $guarded ]]; then
     echo -n "${invers}git $gitcommand${reset} -> execute here (y/n)? "
     read -n 1 -r </dev/tty; echo
     if [[ $REPLY =~ ^[Yy]$ ]]; then
        atomicExecution
     fi
   else
     atomicExecution
   fi
}

# execute a git command with log
function atomicExecution () {
	echo "${bldred}->${reset} executing ${invers}git $gitcommand${reset}"
	git $gitcommand
}

function checkGitCommand () {
	if git help -a | cat | grep -o "$corecommand"; then
		echo "Core command $corecommand accepted."
	else
		usage
		echo "error: unknown GIT command: $corecommand"
		exit 1
	fi
}

# execute the bul operation
function executBulkOp () {
	clear
	listWSDir | while read workspacespec; do
	   wslocation=$(echo $workspacespec | cut -f2 -d' ')
	   eval cd "$wslocation"
	   actual=$(pwd)
	   echo "Executing bulk operation in workspace ${invers}$actual${reset}"
       eval find . -name ".git" | while read line; do
       	  gitrepodir=${line::${#line}-5} # cut the .git part of find results to have the root git directory of that repository
	      eval cd "$gitrepodir" # into git repo location
	      curdir=$(pwd)
	      echo "Current repository: ${curdir%/*}/${bldred}${curdir##*/}${reset}"
	        guardedExecution
	      eval cd "$wslocation" # back to origin location of last find command
       done 
	done 
}

# parse command parameters
while [ "${#}" -ge 1 ] ; do

  case "$1" in
    --workspace)
      shift
      wsname="$1"
      shift
      wsdir="$1"
      addWSDir
      break
      ;;
    --listall)
      listWSDir
      break
      ;;
    -g)
      guarded=true
      ;;
    -*)
	  usage
      echo 1>&2 "error: unknown argument $1"
      exit 1
      ;;
    *)
      corecommand="$1"
      gitcommand="$@"
      checkGitCommand
      executBulkOp
      break
      ;;
  esac

  shift
done
