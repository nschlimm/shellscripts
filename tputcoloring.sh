#!/bin/sh
tbold=$(tput bold) 	   # Start bold text
tsmul=$(tput smul) 	   # Start underlined text
trmul=$(tput rmul) 	   # End underlined text
tinverse=$(tput rev) 	   # Start reverse video
tblink=$(tput blink)   # Start blinking text
tinvis=$(tput invis)   # Start invisible text
tsmso=$(tput smso)     # Start "standout" mode
trmso=$(tput rmso)     # End "standout" mode
reset=$(tput sgr0)     # Turn off all attributes

# Set foreground (fg) and background (bg) color

blackfg=$(tput setaf 0) 
blackbg=$(tput setab 0)

redfg=$(tput setaf 1) 
redbg=$(tput setab 1)

greenfg=$(tput setaf 2) 
greenbg=$(tput setab 2)

yellowfg=$(tput setaf 3) 
yellowbg=$(tput setab 3)

bluefg=$(tput setaf 4) 
bluebg=$(tput setab 4)

magentafg=$(tput setaf 5) 
magentabg=$(tput setab 5)

cyanfg=$(tput setaf 6) 
cyanbg=$(tput setab 6)

whitefg=$(tput setaf 7) 
whitebg=$(tput setab 7)

defaultfg=$(tput setaf 9) 
defaultbg=$(tput setab 9)

defaultreset=${defaultfg}${defaultbg}