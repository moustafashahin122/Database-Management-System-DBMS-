#!/bin/bash
mixedRegex="^[a-zA-Z][a-zA-Z0-9]{4,}$"
numRegex="^[0-9]+$"
stringRegex="^[a-zA-Z]+$"
scriptDir=${PWD}
currentDB=""
echo ${scriptDir}

function tables {
echo "tables MAIN MENU";

echo "select the operation for table"
echo "  1) Create Table "
echo "  2) List Tables"
echo "  3) Drop Table"
echo "  4)Insert into Table" 
echo "  5)Select From Table" 
echo "  6)Delete From Table" 
echo "  7)Update Table" 

read x
  if [ $x -eq 1 ]
  then
 echo "you choose to Create Table" 

   elif [ $x -eq 2 ]
  then
   echo "you choose to list tables"
  ls 
  
   elif [ $x -eq 3 ]
  then
  echo "You choose to Drop Table"
   elif [ $x -eq 4 ]
  then
   echo "you choose to Insert into Table"
   elif [ $x -eq 5 ]
  then
   echo "you choose to Select From Table"
   elif [ $x -eq 6 ]
  then
   echo "you choose to Delete From Table "
   elif [ $x -eq 7 ]
  then
   echo "you choose to Update Table"
 
  else 
   echo "invalid option"
  fi
} 


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
