#!/bin/bash


function mainMenu {
  echo "==============================================="
  echo "DBMS MAIN MENU"
  echo "select the operation ***********"
  echo "  1) Create database"
  echo "  2) List Databases"
  echo "  3) connect to database"
  echo "  4) Drop database"
  read -r n
  if [ $n -eq 1 ]; then
    createDB
    mainMenu
  elif [ $n -eq 2 ]; then
    echo "you choose to list database"
    listDBs
    mainMenu
  # for files ls p |grep -v /
  elif [ $n -eq 3 ]; then
    connectDB
    tablesMenu


  elif [ $n -eq 4 ]; then
    dropDB
    mainMenu
  fi
}






function createDB {
  echo "enter the Database name: "
  read -r dbName
  while ! $(validInput "${dbName}" "${mixedRegex}"); do
    echo "please enter a valid input"
    read -r dbName
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
  echo "enter a data base name to connect "
  read -r dbName
  if [ -d "${scriptDir}"/databases/"${dbName}" ]; then
    cd databases/${dbName} 2>> ./.error.log
    echo " you're connected to ${dbName}"
    pwd
    tables
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
  echo "Enter a databse name to delete "
  read -r dbDelete
  if [ -d "${scriptDir}"/databases/"${dbDelete}" ]; then
    rm -r "${scriptDir}"/databases/"${dbDelete}"
    echo "${dbDelete}" deleted successfully
  else
    echo "Database is not exist"
  fi
}