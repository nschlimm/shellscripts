#!/bin/sh
# sample.mnu
# A simple script menu under Unix
# Main logic starts at MAIN LOGIC
# The logo will be displayed at the top of the screen
LOGO="Sample Menu"

#------------------------------------------------------
# MENU PROMPTS
#------------------------------------------------------
# A list of menu prompts to be displayed for the user.
# The list can be modified.
# In this first list, enter the menu prompt as it should appear
# on the screen for each of the letters A - L. In this example
# menu pick variables emenu through lmenu are blank as there
# are no menu selections for keys E through L.

amenu="a.  Job Scheduling"                ;
bmenu="b.  Set Standard Defaults "        ; 
cmenu="c.  Display Directory Listing "    ; 
dmenu="d   Payroll Menu "                 ;
emenu=" "                                 ;
fmenu=" "                                 ;
gmenu=" "                                 ;
hmenu=" "                                 ;
imenu=" "                                 ;
jmenu=" "                                 ;
kmenu=" "                                 ;
lmenu=" "                                 ;

#------------------------------------------------------
# MENU FUNCTION DEFINITIONS
#------------------------------------------------------
 
# Define a function for invalid menu picks
# The function loads an error message into a variable
badchoice () { MSG="Invalid Selection ... Please Try Again" ; } 
 
# For each prompt displayed above, there is a list of 
# commands to execute in response to the user picking the
# associated letter.
# They are defined as functions
# apick () through lpick () where
# apick () corresponds to the menu
# prompt amenu which is selected
# selected by pressing a or A.
# bpick () corresponds to the menu
# prompt bmenu which is selected by
# pressing b or B and so on.
# Any menu item that is not
# assigned a set of commands, is
# assigned
# the function badchoice () as a default for that pick.
# If the user
# selects a menu key that is assigned
# to badchoice (). This function
# causes an error message to be
# displayed on the screen.
# To add items to this second
# list, replace badchoice ()
# with the commands to run when
# that letter is pressed.
# The following steps simply define
# the functions, but do not cause
# any shell program steps to be executed.

apick () { sched ; }
bpick () { defmnt ; }
cpick () { ls -l| more ; echo Press Enter ; read DUMMY ; }
dpick () { payroll.mnu ; }
epick () { badchoice ; }
fpick () { badchoice ; }
gpick () { badchoice ; }
hpick () { badchoice ; }
ipick () { badchoice ; }
jpick () { badchoice ; }
kpick () { badchoice ; }
lpick () { badchoice ; }

#------------------------------------------------------
# DISPLAY FUNCTION DEFINITION
#------------------------------------------------------
# This function displays the menu.
# The routine clears the screen, echoes
# the logo and menu prompts
# and some additional messages.
# Note that this definition does
# not cause the function to
# be executed yet, it just defines
# it ready to be executed.

themenu () {
# clear the screen
clear
echo `date`
echo
echo "\t\t\t" $LOGO
echo
echo "\t\tPlease Select:"
 echo
 echo "\t\t\t" $amenu
 echo "\t\t\t" $bmenu
 echo "\t\t\t" $cmenu
 echo "\t\t\t" $dmenu
 echo "\t\t\t" $emenu
 echo "\t\t\t" $fmenu
 echo "\t\t\t" $gmenu
 echo "\t\t\t" $hmenu
 echo "\t\t\t" $imenu
 echo "\t\t\t" $jmenu
 echo "\t\t\t" $kmenu
 echo "\t\t\t" $lmenu
 echo "\t\t\tx. Exit"
 echo
 echo $MSG
 echo
 echo Select by pressing the letter and then ENTER ;
 }
  
 #------------------------------------------------------
 # MAIN LOGIC
 #------------------------------------------------------
 # Every thing up to this point has been to define
 # variables or functions.
 # The program actually starts running here.
 
 # Clear out the error message variable
 MSG=
 
 # Repeat the menu over and over
 # Steps are:
 # 1. Display the menu
# 2. 'read' a line of input from the key board
# 3. Clear the error message
# 4. Check the answer for a or A or b or B etc. and dispatch
#    to the appropriate program or function or exit
# 5. If the entry was invalid call the badchoice () function
#    to initialize MSG to an error message
# 6. This error message is used when setting up the menu
#    for a menu pick that is valid but has no command
#    associated with it.

while  true
do
# 1. display the menu
  themenu

# 2. read a line of input from the keyboard
  read answer

# 3. Clear any error message
  MSG=

# 4. Execute one of the defined functions based on the
#    letter entered by the user.

# 5. If the choice was E through L, the pre-defined
#    function for that pick will execute badchoice ()
#    which loads an error message into MSG  

  case $answer in
      a|A) apick;;
      b|B) bpick;;
 c|C) cpick;;
 d|D) dpick;;
 e|E) epick;;
 f|F) fpick;;
 g|G) gpick;;
 h|H) hpick;;
 i|I) ipick;;
 j|J) jpick;;
 k|K) kpick;;
 l|L) lpick;;
#  If the user selects =91x=92 to exit then break out
#  of this loop
      x|X) break;;
 
# 6. If the entry was invalid call the badchoice function
#    to initialize MSG to an error message
        *) badchoice;;
 
  esac
done