PS3='Please enter your choice: '
options=( "Versteckte Dateien in Finder sehen" 
          "Maven analyze dependencies" 
          "Verzeichnisbaum" 
          "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Versteckte Dateien in Finder sehen")
            echo "you chose choice 1"
            defaults write com.apple.finder AppleShowAllFiles -bool TRUE
            break
            ;;
        "Verzeichnisbaum")
            brew install tree
            echo "you chose choice 3"
            ;;

            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done