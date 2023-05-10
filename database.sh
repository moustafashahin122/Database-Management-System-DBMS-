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
function isTypeValid {
  if [[ $1 == num ]] || [[ $1 == string ]]; then
    echo true
  else
    echo false
  fi
}
#Takes 1 parameter :
# $1 -> the database row
# returns the pk column position if exists, 0 in other cases.
function findPrimaryKey {
  IFS=':' read -a splitted_inputs <<<"$1"
  for ((k = 0; k < ${#splitted_inputs[@]}; k++)); do
    if echo ${splitted_inputs[k]} | grep -q "^^"; then
      return $((k + 1))
    else
      if [[ $((${#splitted_inputs[@]} - 1)) == $k ]]; then
        return 0
      fi
    fi
  done
}

#Takes 2 parameters :
# $1 -> line 1 of table file , $2 -> user input
# returns 1 if the pk column in the user input isn't null, 0 in other cases
function validateDataPrimaryKey {
  findPrimaryKey $1
  line_one_pk_index=$?
  IFS=':' read -a splitted_inputs <<<"$2"
  if [[ -z ${splitted_inputs[$((line_one_pk_index - 1))]} ]]; then
    return 0
  else
    return 1
  fi
}

#Takes 1 parameter :
# $1 -> user row input
# returns 0 if any column in row violates the type, 1 in other cases.
function validateRowTypes {
  IFS=':' read -a splitted_inputs <<<"$1"
  for ((i = 0; i < ${#splitted_inputs[@]}; i++)); do
    output=$(isTypeValid ${splitted_inputs[i]})
    if [[ $output == false ]]; then
      return 0
    else
      if [[ $((${#splitted_inputs[@]} - 1)) == $i ]]; then
        return 1
      fi
    fi
  done
}

# ***********************************************************************************

function createTable {
  echo " please enter a name for the table"
  validInput "${mixedRegex}"
  tableName="${input}"
  echo " ***********************************"
  if [ ! -f "${tableName}" ]; then
    touch "${tableName}"
    echo " you've created the table ${tableName}"

    while true; do
      printf 'Enter your columns seperated by ':', and the primary key perceded by ^ ex => ^col1:col2:col3\n'
      validInput "${mixedRegexWithColon}"

      table_columns="${input}"

      echo "*********************************************"
      num_of_cols=$(awk -F":" '{print NF}' <<<"${table_columns}")
      findPrimaryKey $table_columns
      fpk_return_val=$?
      if [[ $fpk_return_val == 0 ]]; then
        printf "\nError: couldn't find pk. Please try again and add a primary key.\n"
      else
        echo $table_columns >$tableName
        break
      fi
    done
    while true; do
      printf 'Enter your columns data types in the same format.\navailable data types: num , string\n'
      read table_types
      echo "*********************************************"

      num_of_types=$(awk -F":" '{print NF}' <<<"${table_types}")
      if [[ $num_of_types != $num_of_cols ]]; then
        printf "Error: Your datatypes count is '$num_of_types' \nwhich is not equal to your columns count '$num_of_cols' \n"
        continue
      fi
      validateRowTypes $table_types
      vrt_return_val=$?
      if [[ $vrt_return_val == 0 ]]; then
        printf "Error: a datatype you entered is not num neither string, please try again with the correct data types.\n"
      else
        echo $table_types >>$tableName
        printf "Table $table_name created successfully\n"
        break
      fi
    done

  else
    echo "table already exists"
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
