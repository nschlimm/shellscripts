#!/bin/sh
COLUMNS=100
select choice in \
    "Maven clean all" \
    "Maven analyze dependencies" \
    "Maven clean install force updates" \
    "Goto local Maven Repository" \
    "Install third party lib to local repo manually" \
    "Install maven build lib to local repo manually" \
    "Show effective settings" \
    "Show local repository location" \
    "Show global settings file location" \
    "Show user settings file location" \
    "Remove reresolve all dependencies of Project from local Repository" \
    "List repositories of Project" \
    "Download sources" \
    "Build with dependencies" \
    "Quit"

do
    case $REPLY in
        1)
            mvn clean:clean
            mvn eclipse:clean
            mvn eclipse:eclipse
        ;;
        2)
            mvn dependency:analyze
        ;;
        3)
            mvn clean install -U -DskipTests
        ;;
        4)
            cd /Users/niklasschlimm/.m2/repository
        ;;
            
        5)
            echo "relative file name:"
            read fname
            echo "local maven repo group id"
            read fgroupid
            echo "local maven repo artifact id"
            read artifactid
            echo "version"
            read version
            echo "packaging"
            read packaging
            mvn install:install-file -Dfile=$fname -DgroupId=$fgroupid -DartifactId=$artifactid -Dversion=$version -Dpackaging=$packaging
        ;;
        6)
            echo "full qualified source file name:"
            read fname
            mvn install:install-file -Dfile=$fname
            ;;
        7)
            mvn help:effective-settings
            ;;
        8)
            mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'
            ;;
        9)
            OUTPUT="$(mvn -X | grep -F '[DEBUG] Reading global settings from')"
            echo ${OUTPUT:37}
            read -p "Open global settings? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                vim ${OUTPUT:37}
            fi      
            ;;
        10)
            OUTPUT="$(mvn -X | grep -F '[DEBUG] Reading user settings from')"
            echo ${OUTPUT:35}
            read -p "Open user settings? " -n 1 -r
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
                then
                vim ${OUTPUT:35}
            fi      
            ;;
        11)
            mvn dependency:purge-local-repository
        ;;
        12)
            mvn dependency:list-repositories
        ;;
        13)
            mvn dependency:sources
            mvn eclipse:eclipse -DdownloadSources=true
            ;;
        14)
            mvn clean compile assembly:single
            ;;
        15)
            echo "Okay, .."
            break
            ;;
    esac

done
