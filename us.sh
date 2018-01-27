#!/bin/sh
COLUMNS=80
select choice in \
    "View Contents of JAR" \
    "Show all environment variables" \
    "Add an env avriable to profile" \
    "Add path to path variable" \
    "Search for a resource in jar files" \
    "Quick search for a resource in jar files" \
    "Who uses port xy?" \
    "Find file in directory" \
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
            echo "Enter file name:"
            read fname
            cm="jar tf {} | grep $fname &&  echo {}"
            eval find * -type f -name '*.jar' -print0 |  xargs -0 -I '{}' sh -c "$cm"
            break

        ;;
        6)
            echo "Enter file name:"
            read fname
            eval find * -name "*.jar" | xargs grep $fname
            break

        ;;
        7)
            echo "Enter port:"
            read portno
            lsof -n -i:$portno | grep LISTEN
            break
        ;;
        8)
            echo "Search pattern:"
            read pattern
            find . -iname "$pattern"
            break
        ;;
        9)
            break
        ;;
    esac
    break #stops From Re-Looping After Chooseing

done