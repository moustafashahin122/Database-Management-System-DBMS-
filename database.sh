#!/bin/bash
mixedRegex="^[a-zA-Z][a-zA-Z0-9]+$"
numRegex="^[0-9]+$"
stringRegex="^[a-zA-Z]+$"
currentDir=${PWD}
echo ${currentDir}

function mainMenu {

  echo "DBMS MAIN MENU"

  echo "select the operation ***********"
  echo "  1) Create database"
  echo "  2) List Databases"
  echo "  3) connect to database"
  echo "  4) Drop database"

  read n

  if [ $n -eq 1 ]; then
    createDB

  elif [ $n -eq 2 ]; then
    listDBs
  # for files ls p |grep -v /

  elif [ $n -eq 3 ]; then
    echo "You choose to connect to database"
    read -p "enter a data base name to connect " dbConnect
    cd databases/$dbConnect

  elif [ $n -eq 4 ]; then
    dropDB
  else
    echo "invalid option"
    echo "please enter a valid option"

  fi
}

function createDB {
  read -rp "enter the Database name " dbName

  while ! $(validInput "${dbName}" "${mixedRegex}"); do
    echo please enter a valid input
    read -rp "enter the Database name " dbName
  done
  if [ ! -d "${dbName}" ]; then
    mkdir -p "${currentDir}"/databases/"${dbName}"

    echo " you've created ${dbName}"

  else
    echo "data base already exists"

  fi
}

function listDBs {
  echo "you choose to list database"
  cd "${currentDir}"/databases
  ls
  cd "${currentDir}"

}
function dropDB {
  echo "you choose to drop database"
  cd "${currentDir}"/databases
  ls
  cd "${currentDir}"
  read -rp "Enter a databse name to delete " dbDelete
  if [ -d "${currentDir}"/databases/"${dbDelete}" ]; then
    rmdir "${currentDir}"/databases/"${dbDelete}"
    echo "${dbDelete}" deleted successfully
  else
    echo "Database is not exist"
  fi
}
# function connectDB{

# }
# general check to make sure that the user input is valid
# -doesn't start with a number
# -doesn't containt special characters
# no spaces

function validInput {
  # this function taske two argument the first is a string you want to check and the second is a regex
  if [[ $1 =~ ${2} ]]; then
    echo true
  else
    echo false
  fi
}

mainMenu
