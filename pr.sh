#!/bin/sh
select choice in \
    "Neues Projekt anlegen" \
    "Service anlegen infrastruktur - angepasste Files" \
    "Front-End mit Service in STS nutzen - Beschreibung" \
    "Add service to front end - angepasste Files" \
    "Quit"

do
    case $REPLY in
        1)
            echo "Befehl erwartet, das du dich im neu erstellten und geclonten Projektverzeichnis befindest. <taste drücken>"
            read
            echo "Projektname?"
            read projektname
            mvn archetype:generate -DartifactId=$projektname \
                                   -DinteractiveMode=true
            mv $projektname/* .
            rm -rf $projektname/
            mvn compile
            mvn eclipse:eclipse
            git status > .gitignore
            vim .gitignore
            break
            ;;
        2) 
        echo "Drill down into file diff: 
        M  carriertech-app/carriertech-app-dev/ApplicationManifest.xml 
        M  carriertech-app/carriertech-app-test/ApplicationManifest.xml 
        M  docker-compose/docker-compose.yml 
        M  resource-templates/azuredeploy.json 
        M  resource-templates/keyvault_script/keyvaultSecrets.ps1 
        A  carriertech-app/carriertech-app-dev/AufgabenServicePkg/ServiceManifest.xml 
        A  carriertech-app/carriertech-app-dev/AufgabenServicePkg/code/artifact.load 
        A  carriertech-app/carriertech-app-int/AufgabenServicePkg/ServiceManifest.xml 
        A  carriertech-app/carriertech-app-int/AufgabenServicePkg/code/artifact.load 
        A  carriertech-app/carriertech-app-prod/AufgabenServicePkg/ServiceManifest.xml 
        A  carriertech-app/carriertech-app-prod/AufgabenServicePkg/code/artifact.load 
        A  carriertech-app/carriertech-app-test/AufgabenServicePkg/ServiceManifest.xml 
        A  carriertech-app/carriertech-app-test/AufgabenServicePkg/code/artifact.load "
        break
        ;;
        3) 
        echo "
            npm install
            dockerlocal-template.js kopieren und dockerlocal.js umbenennen
            dann darin den service port auf den localen sts service umdengeln
            yarn ct-dev-docker"
        break
        ;;
        4) 
        echo "
        M  server/devlocal-template.js
        M  server/dockerlocal-template.js
        M  server/server.js
        A  src/actions/aufgaben_actions.js
        M  src/components/aufgabenView/AufgabenUebersichtView.js
        A  src/reducers/aufgaben_reducer.js
        M  src/reducers/index.js
        A  src/sagas/aufgaben_saga.js
        M  src/sagas/index.js
        M  src/utils/communication.js"
        break
        ;;
        5)
            echo "Okay, Exiting..."
            break
        ;;

    esac
    break #stops From Re-Looping After Chooseing

done
