#!/bin/sh
composefileloc=~/workspaces/carriertech/infrastructure/docker-compose
select choice in \
    "Docker aktualisieren" \
    "Docker starten" \
    "Docker stoppen" \
    "Docker log in" \
    "Docker log out" \
    "Docker Prozesse anzeigen" \
    "Quit"

do
    case $REPLY in
        1)
            act=$PWD
            cd $composefileloc
            docker-compose pull 
            cd $act
        ;;
        2) 
            act=$PWD
            cd $composefileloc
            docker-compose up 
            cd $act
        ;;
        3) 
            act=$PWD
            cd $composefileloc
            docker-compose stop 
            cd $act
        ;;
        4) 
            docker login -u crsdirt -p '==CAH=zf+/luJFDc+V+PSmXJA=je=zFC' crsdirt.azurecr.io
        ;;
        5) 
            docker logout
        ;;
        6) 
            docker ps
        ;;
        7) 
            echo "Okay, Exiting..."
            break
        ;;

    esac
    break #stops From Re-Looping After Chooseing

done
