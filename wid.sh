PS3='Please enter your choice: '
options=( "Versteckte Dateien in Finder sehen" 
          "Maven analyze dependencies" 
          "Verzeichnisbaum" 
          "Diff so fancy" 
          "Brew" 
          "Mergetool"
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
            ;;

        "Diff so fancy")
            brew update
            brew install diff-so-fancy
            ;;

        "Brew")
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            ;;

        "Mergetool")
            # Tell system when Xcode utilities live:
            sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
            
            # Set "opendiff" as the default mergetool globally:
            git config --global merge.tool opendiff
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done