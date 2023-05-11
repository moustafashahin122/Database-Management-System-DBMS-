#!/bin/bash
mixedRegex="^[a-zA-Z][a-zA-Z0-9]{4,}$"
mixedRegexWithColon="^([\^a-zA-Z][\^:a-zA-Z0-9]{3,})+$"
numRegex="^[0-9]+$"
stringRegex="^[a-zA-Z]+$"
scriptDir=${PWD}
databasesDir="${scriptDir}/databases"
currentDB=""

function tablesMenu {
  cd ${currentDB}
  echo "****************************************"
  echo "tables MAIN MENU"

  echo "select the operation for table"
  echo "  1) Create Table "
  echo "  2) List Tables"
  echo "  3) Drop Table"
  echo "  4)Insert into Table"
  echo "  5)Select From Table"
  echo "  6)Delete From Table"
  echo "  7)Update Table"
  echo "  8)disconnect"

  read -r x
  echo " ***********************************"

  if [ $x -eq 1 ]; then
    createTable
    tablesMenu
  elif [ $x -eq 2 ]; then
    echo "you choose to list tables"
    ls
    pwd
    tablesMenu

  elif [ $x -eq 3 ]; then
    echo "You choose to Drop Table"
  elif [ $x -eq 4 ]; then
    echo "you choose to Insert into Table"
  elif [ $x -eq 5 ]; then
    echo "you choose to Select From Table"
  elif [ $x -eq 6 ]; then
    echo "you choose to Delete From Table "
  elif [ $x -eq 7 ]; then
    echo "you choose to Update Table"
  elif [ $x -eq 8 ]; then
    echo "you choose to disconnect"
    mainMenu

  else
    echo "invalid option"
  fi
}

# *********************************************************************************

# ***********************************************************************************

function createTable {
  echo " please enter a name for the table"
  validInput "${mixedRegex}"
  tableName="${input}"
  echo " ***********************************"
  if [ ! -f "${tableName}" ]; then
    touch "${tableName}"
    touch "${tableName}_metadata"

    read -p "Enter number of columns :" cols
    echo " ***********************************"

    if [[ $cols -eq 0 ]]; then
      echo Cannot create a table without columns
      tablesMenu
    fi

    $(chmod -R 777 "${tableName}")
    $(chmod -R 777 "${tableName}_metadata")
    echo "Table Name:"$tableName >>$tableName"_metadata"
    echo "Number of columns:"$cols >>$tableName"_metadata"

    for ((i = 1; i <= cols; i++)); do
      if [[ i -eq 1 ]]; then
        read -p "Enter column $i name as a primary key: " name
        echo "The primary key for this table is: "$name >>$tableName"_metadata"
        echo "Names of columns: " >>$tableName"_metadata"
        echo -n $name"," >>$tableName"_metadata"

      elif [[ i -eq cols ]]; then
        read -p "Enter column $i name: " name
        echo -n $name >>$tableName"_metadata"
      else
        read -p "Enter column $i name: " name
        echo -n $name"," >>$tableName"_metadata"
      fi
    done
    clear
    echo " you've created the table ${tableName}"
    tablesMenu

  else
    echo "table already exists"
    tablesMenu
  fi
}

source MainMenu.sh

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
