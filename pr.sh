#!/bin/sh
select choice in \
    "Neues Projekt anlegen" \
    "Quit"

do
    case $REPLY in
        1)
            mvn archetype:generate
            
            echo "Projektname?"
            read projektname
            error=$(cd $projektname 2>&1 )
            echo $error
            echo $error
            pushd $projektname
            if [[ $error == *"No such file"* ]]; then
                echo "Muss abbrechen, kein Projektverzeichnis!"
                break
            fi
            mvn compile
            mvn eclipse:eclipse
            git init
            git status > .gitignore
            vim .gitignore
            read -p "Push initial to remote master? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                 a="git@git.codecentric.de:s-direkt/"
                 b=".git"
                 c=$a$projektname$b
                 git remote add origin $c
                 git add .
                 git commit -m "Initial"
                 mvn eclipse:eclipse
            fi      
            popd
            break
            ;;
        2)
            echo "Okay, Exiting..."
            break
        ;;
    esac
    break #stops From Re-Looping After Chooseing

done
