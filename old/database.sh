#!/bin/bash
# mixedRegex to validate filesname to be at least 3 charaters and doesn't start with a number and doesn't contain and special character
mixedRegex="^[a-zA-Z][a-zA-Z0-9]{2,}$"
#regex to validate number of columns
numRegex="^[1-9]+$"
#to make sure user input for menus is numbers
numRegexy="^[0-9]+$"
#validate col name to be at least 2 char with no numbers
colNameRegex="^[a-zA-Z]{2,}$"
#validate data to be inserted into table to be at least on char

insertRegex="^[a-zA-Z0-9]+$"
scriptDir=${PWD}
databasesDir="${scriptDir}/databases"
currentDB=""

source MainMenu.sh
source TablesMenu.sh

# function connectDB{

# }
# general check to make sure that the user input is valid
# -doesn't start with a number
# -doesn't containt special characters
# no spaces

function validInput {
  # this function taske two argument the first is a string you want to check and the second is a regex

  read -r input
  echo " ***********************************"

  while ! [[ $input =~ ${1} ]]; do
    echo "please enter a valid input"
    read -r input
    echo " ***********************************"

  done

}
mainMenu
