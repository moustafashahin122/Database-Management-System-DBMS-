#!/bin/bash


function tablesMenu {
  cd ${currentDB}
  echo "****************************************"
  echo "TABLES  MENU"

  echo "select the operation for table"
  echo "  1) Create Table "
  echo "  2) List Tables"
  echo "  3) Drop Table"
  echo "  4) Insert into Table"
  echo "  5) Select From Table"
  echo "  6) Delete From Table"
  echo "  7) change column name"
  echo "  8) metadata"
  echo "  9) disconnect"

  read -r x
  echo " ***********************************"

  if [ $x -eq 1 ]; then
    createTable
    tablesMenu
  elif [ $x -eq 2 ]; then
    echo "you choose to list tables"
    listTables
    tablesMenu

  elif [ $x -eq 3 ]; then
    dropTable
    tablesMenu

  elif [ $x -eq 4 ]; then
    insertIntoTable
  elif [ $x -eq 5 ]; then
    echo "you choose to Select From Table"
    selectFromTable
    tablesMenu
  elif [ $x -eq 6 ]; then
    echo "you choose to Delete From Table "
    deleteFromTable
    tablesMenu
  elif [ $x -eq 7 ]; then
    echo "you choose to change column name"
    changColName
  elif [ $x -eq 8 ]; then
    metadataFun
  elif [ $x -eq 9 ]; then
    echo "you choose to disconnect"
    mainMenu

  else
    echo "invalid option"
  fi
}
function deleteFromTable {

  clear
  listTables
  read -p "Enter table name to delete from: " tableName
  if [[ -f "${tableName}" ]]; then
    select choice in "delete all records" "delete a specific record"; do
      case $REPLY in
      1)
        echo "" >"${tableName}"
        echo All records has been deleted
        echo
        tablesMenu
        ;;

      2)
        pk_name=$(awk -F, '{if(NR==5){print$1}}' ".${tableName}_metadata")
        read -p "Enter $pk_name value: " val
        pks=$(sed -n '1,$'p "${tableName}" | cut -f1 -d,)

        for j in $pks; do
          if [[ $j -eq "$val" ]]; then
            grep -v ^$val "${tableName}" >temp.csv
            mv temp.csv "${tableName}"
            rm temp.csv 2>/dev/null
            echo record with id : $val had been deleted
            tablesMenu

          fi
        done
        echo "this record doesn't exist"
        tablesMenu
        ;;

      esac
    done

  else
    echo There is no table with this name
    echo
    echo -----------------
    tablesMenu
  fi

}

function selectFromTable {
  clear
  echo
  listTables
  read -p "Enter table name to select from: " tableName
  if [[ -f "${tableName}" ]]; then
    select choice in "select all" "select specific records"; do
      case $REPLY in
      1)
        awk 'BEGIN{FS=","} {if(NR==5){for (i=1;i<=NF;i++) printf "%-10s",$i; print " "}}' ".${tableName}_metadata"
        awk 'BEGIN{FS=","}{for (i=1;i<=NF;i++) printf "%-10s ",$i; print " "}' "${tableName}"
        echo
        echo

        ;;

      2)
        pk_name=$(awk -F, '{if(NR==5){print$1}}' ".${tableName}_metadata")
        read -p "Enter $pk_name value: " val
        awk 'BEGIN{FS=","} {if(NR==5){for (i=1;i<=NF;i++) printf "%-10s",$i; print " "}}' ".${tableName}_metadata"
        cat "${tableName}" | grep ^$val >temp2
        awk 'BEGIN{FS=","}{for (i=1;i<=NF;i++) printf "%-10s",$i; print " "}' temp2
        rm temp2 2>/dev/null

        echo
        echo

        ;;
      *)
        echo wrong choice

        ;;
      esac
    done
    echo
  else
    echo
    echo There is no table with this name

  fi
}

function metadataFun {
  listTables
  read -rp "Enter the table name: " tableName
  if [[ -f ".${tableName}_metadata" ]]; then
    cat ".${tableName}_metadata"
    echo
  else
    echo There is no table with this name
  fi
  echo ------------------
  tablesMenu
}

function listTables {

  ls

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
    touch ".${tableName}_metadata"

    echo " please enter the number of columns"
    validInput "${numRegex}"
    cols="${input}"
    echo " ***********************************"

    $(chmod -R 777 "${tableName}")
    $(chmod -R 777 ".${tableName}_metadata")
    echo "Table Name:"$tableName >>".${tableName}_metadata"
    echo "Number of columns:"$cols >>".${tableName}_metadata"
    echo " ***********************************"

    for ((i = 1; i <= cols; i++)); do
      if [[ i -eq 1 ]]; then

        echo "Enter column $i name as a primary key: "
        validInput "${colNameRegex}"
        name="${input}"

        echo "The primary key for this table is: "$name >>".${tableName}_metadata"
        echo "Names of columns: " >>".${tableName}_metadata"
        echo -n $name"," >>".${tableName}_metadata"

      elif [[ i -eq cols ]]; then
        echo "Enter column $i name: "

        validInput "${colNameRegex}"
        name="${input}"
        echo -n $name >>".${tableName}_metadata"
      else
        echo "Enter column $i name: "

        validInput "${colNameRegex}"
        name="${input}"
        echo -n $name"," >>".${tableName}_metadata"
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
function changColName {
  listTables
  echo "Enter the name of the table you want to update: "
  validInput "${mixedRegex}"
  tableName="${input}"

  if [ -f "${tableName}" ]; then
    echo "Table exists. Enter the name of the column you want to update: "

    awk -F, '{if(NR==5){print $0}}' ".${tableName}_metadata"

    validInput "${colNameRegex}"
    columnName="${input}"

    if grep -q "$columnName" ".${tableName}_metadata"; then
      echo "Enter the new name for the column: "
      validInput "${colNameRegex}"
      newColumnName="${input}"

      sed -i "s/$columnName/$newColumnName/g" ".${tableName}_metadata"
      echo "Column name updated successfully."
      awk -F, '{if(NR==5){print $0}}' ".${tableName}_metadata"

      tablesMenu
    else
      echo "Column does not exist in the table."
      tablesMenu
    fi
  else
    echo "Table does not exist."
    tablesMenu
  fi
}
function dropTable {
  echo "You choose to Drop Table"
  listTables
  echo "Enter a table name to delete "
  read -r tableDrop
  if [ -f "${tableDrop}" ]; then
    rm "${tableDrop}"
    rm ".${tableDrop}_metadata"
    echo "${tableDrop}" deleted successfully
  else
    echo "table does not exist"
  fi
}

function insertIntoTable {

  echo "you choose to Insert into Table"
  listTables
  read -rp "Enter the table name: " tableName

  echo "************************************************"
  if [[ -f "${tableName}" ]]; then
    typeset -i cols=$(awk -F, '{if(NR==5){print NF}}' ".${tableName}_metadata")

    for ((i = 1; i <= $cols; i++)); do
      colname=$(awk -F, -v"i=$i" '{if(NR==5){print $i}}' ".${tableName}_metadata")
      echo "Enter $colname: "
      validInput "${insertRegex}"
      value="${input}"

      if [[ $colname -eq id ]]; then
        pks=$(sed -n '1,$'p "${tableName}" | cut -f1 -d,)
        for j in $pks; do
          if [[ $j -eq $value ]]; then
            echo "cannot repeat primary key"
            tablesMenu
          fi
        done
      fi
      if [[ $i != $cols ]]; then
        echo -n $value"," >>"${tableName}"
      else
        echo $value >>"${tableName}"
      fi
    done
    echo "Data has been sorted successfully"
    echo
    echo
    tablesMenu

  else
    echo "${tableName} doesn't exist"
    echo
    tablesMenu
  fi

}