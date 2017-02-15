#!/bin/sh
COLUMNS=80
select choice in \
    "View Contents of JAR" \
    "Show all environment variables" \
    "Add an env avriable to profile" \
    "Add path to path variable" \
    "To local workspace historisierung-lib" \
    "Quit"

do
    case $REPLY in
        1)
            ls -l
            echo "Name of jar file"
            read jarname
            jar tf $jarname
            break

        ;;
        2)
            env
            break

        ;;
        3)
            vim ~/.bash_profile
            break

        ;;
        4)
            echo "Add the path to add"
            read npath
            export PATH=$PATH:$npath
            break

        ;;
        5)
            cd /Users/niklasschlimm/workspaces/carriertech/historisierung-lib
            break

        ;;
        6)
            break
        ;;
    esac
    break #stops From Re-Looping After Chooseing

done