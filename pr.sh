#!/bin/sh
select choice in \
    "Neues Projekt anlegen" \
    "Service anlegen infrastruktur - angepasste Files" \
    "Front-End Entwicklung aufsetzen und Micro Service in STS nutzen - Beschreibung" \
    "Add service to front end - angepasste Files" \
    "MVC Integrationstest schreiben - Beispiel Files" \
    "Mitarbeitert und Kundencenter Lokal betreiben" \
    "Fehleranalyse - Service auf Service Fabric Knoten starten" \
    "Fehleranalyse - Backend Server Log beim start ausgeben" \
    "Passwort in Repos anpassen" \
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
        1      M  carriertech-app/carriertech-app-dev/ApplicationManifest.xml
        2      A  carriertech-app/carriertech-app-dev/BerechnungsServicePkg/ServiceManifest.xml
        3      A  carriertech-app/carriertech-app-dev/BerechnungsServicePkg/code/artifact.load
        4      M  carriertech-app/carriertech-app-int/ApplicationManifest.xml
        5      A  carriertech-app/carriertech-app-int/BerechnungsServicePkg/ServiceManifest.xml
        6      A  carriertech-app/carriertech-app-int/BerechnungsServicePkg/code/artifact.load
        7      M  carriertech-app/carriertech-app-prod/ApplicationManifest.xml
        8      A  carriertech-app/carriertech-app-prod/BerechnungsServicePkg/ServiceManifest.xml
        9      A  carriertech-app/carriertech-app-prod/BerechnungsServicePkg/code/artifact.load
        10     M  carriertech-app/carriertech-app-test/ApplicationManifest.xml
        11     A  carriertech-app/carriertech-app-test/BerechnungsServicePkg/ServiceManifest.xml
        12     A  carriertech-app/carriertech-app-test/BerechnungsServicePkg/code/artifact.load
        13     M  docker-compose/docker-compose.yml
        14     M  keyvault/secrets-dev.js
        15     M  keyvault/secrets-test.js
        16     M  resource-templates/azuredeploy-ai.json       

        Dann in resource-templates/ für dev:
        VPN trennen
        npm install
        node index.js pd05417@ads.provinzial.com ${PASSWORD} '31cf0c9f-711c-4a90-8d53-72c20e8224eb' 'RG_SDSF01D' 'azuredeploy-ai.json' 'd'

        Dann für test:
        node index.js pd05417@ads.provinzial.com ${PASSWORD} '31cf0c9f-711c-4a90-8d53-72c20e8224eb' 'RG_SDSF01T' 'azuredeploy-ai.json' 't'

        Dann deployen über Jenkins

        Jetzt aufpassen: application insights id setzen ! Dazu in Umgebung wenn AI Insight für Service angelegt in AI Service rein gehen Eigenschaften>Instrumentierungsschlüssel kopieren und in jeweiliger ApplicationManifest Datei für die Umgebung beim Service eintragen.

        Nochmal deployen. 

        Im Projekt logback-spring.xml den richtigen LogFile eintragen:  value='${java.io.tmpdir:-/tmp}/berechnungs-service.log}'/>

        Schon fertig :-)
        " 


        break
        ;;
        3) 
        echo "
            1) npm install im basis ordner
            2) npm install im server ordner
            3) dockerlocal-template.js oder devlocal-template kopieren und dockerlocal.js bzw. devlocal.js umbenennen
            4) dann darin den service port auf den localen sts service umdengeln z.B. haftpflichtServiceUrl:'https://localhost:8999'
               Ansonsten die Testadressen für die Services: z.B. TEST -> sachServiceUrl:'https://10.53.231.68:8002'
            5) in STS den lokalen service im application.properties -> server.port=8099 setzen und dann auch das jeweilige Profil setzen: spring.profiles.active=...,...,test
            5) yarn ct-dev-docker oder ct-dev-local
            6) public/index.html werte für Rechner ersetzen wenn die benötigt werden:
               https://sdir-ct-t-mitarbeitercenter.provinzial.com/tarifrechner/hausrat/content_start.jsp
               https://sdir-ct-t-mitarbeitercenter.provinzial.com/tarifrechner/haftpflicht/content_start.jsp
               ->       window.phvRechnerUrl = "/REPLACE_ME_PHV_RECHNER_URL";
                        window.vhvRechnerUrl = "/REPLACE_ME_VHV_RECHNER_URL";
            7) Einmal in einem seperaten Fenster https://sdir-ct-t-mitarbeitercenter.provinzial.com/tarifrechner/hausrat/content_start.jsp aufrufen, um sich in die Firewall einzuloggen
            8) -> tina@prisons.de / Aa12345678
            "


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
        echo "
        src/test/java/de/sdirekt/carriertech/sach/TestSwaggerWebSecurityConfiguration.java
        src/test/java/de/sdirekt/carriertech/sach/TestUtilsVertrag.java
        src/test/java/de/sdirekt/carriertech/sach/endpoint/OAuthHelper.java
        src/test/java/de/sdirekt/carriertech/sach/endpoint/SachControllerIntegrationTest.java
        "
        ;;
        6)
        echo "Mitarbeitercenter devlocal.js
        exports.conf = {
        kundencenterUrl: 'https://localhost:3001',
        identServiceUrl: 'https://10.53.232.68:8000',
        partnerServiceUrl: 'https://10.53.232.68:8001',
        haftpflichtServiceUrl: 'https://10.53.232.68:8002',
        hausratServiceUrl: 'https://10.53.232.68:8002',
        postboxServiceUrl: 'https://10.53.232.68:8004',
        mitarbeiterIdentServiceUrl: 'https://10.53.232.68:8007',
        aufgabenServiceUrl: 'https://10.53.232.68:8012',
        kfzServiceUrl: 'https://10.53.232.68:8010'
        };

        Kundencenter devlocal.js
        const isMitarbeiterKundencenter = true;
        let conf = {
           isMitarbeiterKundencenter: isMitarbeiterKundencenter,
           kundencenterUrl: 'https://localhost:3001',
           identServiceUrl: isMitarbeiterKundencenter ? 'https://10.53.232.68:8007' : 'https://localhost:8080',
           partnerServiceUrl: 'https://10.53.232.68:8001',
           haftpflichtServiceUrl: 'https://localhost:8080',
           sachServiceUrl: 'https://localhost:8080',
           hausratServiceUrl: 'https://localhost:8080',
           postboxServiceUrl: 'https://10.53.232.68:8004',
           mitarbeiterIdentServiceUrl: 'https://10.53.232.68:8007',
           kfzServiceUrl: 'https://10.53.232.68:8010',
        ;
                exports.conf = conf;

        Einen Backend Service Zertifikat akzeptieren
        1. https://localhost:3001 aufrufen und zertifikat akzeptieren
        2. sdir-ct-d-front-to-back.provinzial.com:8007 aufrufen und zertifikat akzeptieren
        "
        ;;
        7)
        echo "
            Remote Desktop Verbindung: 10.53.232.70:3389
            Dann Beispiel: D:\SvcFab\_App\carriertech-app-dev_App269\AufgabenServicePkg.Code.1.0.0
            dann Anwendung lokal starten Beispiel: jre\bin\java.exe -jar service.jar --applicationId='8ed07fa9-3895-4bf9-b74d-cd2f39dba86e' --applicationSecret='HEw+hDPWZWPhpUwGmI5l10Oty0kU1QssohZFJTmopMA=' --keyVaultUri='https://kv-sdsf01d.vault.azure.net/'
            break
            "
        ;;

        8)
        echo "https://10.53.232.69:8005/log/view?filename=aktivitaeten-service.log&base=";
            break
        ;;
        9)
            . ~/workspaces/personal/shellscripts/userpas.sh
            break
        ;;
        10)
            echo "Okay, Exiting..."
            break
        ;;

    esac
    break #stops From Re-Looping After Chooseing

done
