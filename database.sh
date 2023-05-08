#!/bin/bash
mixedRegex="^[a-zA-Z][a-zA-Z0-9]+$"
numRegex="^[0-9]+$"
stringRegex="^[a-zA-Z]+$"
scriptDir=${PWD}
currentDB=""
echo ${scriptDir}

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
    echo "you choose to list database"
    listDBs
  # for files ls p |grep -v /

  elif [ $n -eq 3 ]; then
    connectDB

  elif [ $n -eq 4 ]; then
    dropDB

  fi
}

function createDB {
  read -rp "enter the Database name " dbName

  while ! $(validInput "${dbName}" "${mixedRegex}"); do
    echo please enter a valid input
    read -rp "enter the Database name " dbName
  done
  if [ ! -d "${dbName}" ]; then
    mkdir -p "${scriptDir}"/databases/"${dbName}"

    echo " you've created ${dbName}"

  else
    echo "data base already exists"

  fi
}
function connectDB {

  echo "You choose to connect to database"
  listDBs
  read -rp "enter a data base name to connect " dbName
  if [ -d "${scriptDir}"/databases/"${dbName}" ]; then
    cd databases/${dbName}
    echo " you're connected to ${dbName}"
    pwd
  else
    echo "no database with such name"
  fi

}
function listDBs {
  cd "${scriptDir}"/databases
  ls
  cd "${scriptDir}"

}
function dropDB {
  echo "you choose to drop database"
  listDBs
  read -rp "Enter a databse name to delete " dbDelete
  if [ -d "${scriptDir}"/databases/"${dbDelete}" ]; then
    rm -r "${scriptDir}"/databases/"${dbDelete}"
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
