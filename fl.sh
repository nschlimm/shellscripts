#!/bin/sh
COLUMNS=80
select choice in \
    "To local maven repo root" \
    "To local workspace carriertech" \
    "To local workspace hausrat-service" \
    "To local workspace import-service" \
    "To local workspace historisierung-lib" \
    "To local workspace haftpflicht-service" \
    "To local workspace bfsach-migration" \
    "To local shellscripts" \
    "Quit"

do
    case $REPLY in
        1)
            cd /Users/niklasschlimm/.m2/repository
            break

        ;;
        2)
            cd /Users/niklasschlimm/workspaces/carriertech
            break

        ;;
        3)
            cd /Users/niklasschlimm/workspaces/carriertech/hausrat-service
            break

        ;;
        4)
            cd /Users/niklasschlimm/workspaces/carriertech/import-service
            break

        ;;
        5)
            cd /Users/niklasschlimm/workspaces/carriertech/historisierung-lib
            break

        ;;
        6)
            cd /Users/niklasschlimm/workspaces/carriertech/haftpflicht-service
            ;;
        7)
            cd /Users/niklasschlimm/workspaces/carriertech/bfsach-migration
            ;;
        8)
            cd /Users/niklasschlimm/Personal
            break

        ;;
        9)
            break
        ;;
    esac
    break #stops From Re-Looping After Chooseing

done