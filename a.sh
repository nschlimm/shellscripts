#!/bin/bash
# "Two Words" Makes It Count As One Object, 
# But If It Is A Single Word,You Don't Need The ""
select choice in \
    "Start Server" \
    "Update Server" \
    Exit
do
    case $REPLY in
        1)
            echo Start Server...

        ;;
        2)
            echo Update Server...

        ;;
        3)
            echo "Okay, Exiting..."
            exit
        ;;
    esac
    break #stops From Re-Looping After Chooseing

done