PS3='Please enter your choice: '
options=( "Versteckte Dateien in Finder sehen" 
          "Verzeichnisbaum" 
          "Diff so fancy" 
          "Brew" 
          "Difftool"
          "Mergetool"
          "git-extras"
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

        "Difftool")
            echo "Paste the following code:"
            echo "#!/bin/sh" 
            echo "/usr/bin/opendiff \"$2\" \"$5\" -merge \"$1\""
            # Make the bash script executable:
            vi ~/bin/git-diff-cmd.sh
            chmod +x ~/bin/git-diff-cmd.sh
            # Tell Git (globally) to run our bash script when 'git diff' is issued:
            git config --global diff.external ~/bin/git-diff-cmd.sh
            ;;
        "git-extras")
            brew install git-extras
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done