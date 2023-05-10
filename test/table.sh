#!/bin/bash
scriptDir=${PWD}

function createTable {

  echo "Enter a table name"
  read -r tableName
  touch "${tableName}.db"
}

echo "tables MAIN MENU"

echo "select the operation for table"
echo "  1) Create Table "
echo "  2) List Tables"
echo "  3) Drop Table"
echo "  4) Insert into Table"
echo "  5) Select From Table"
echo "  6) Delete From Table"
echo "  7) Update Table"

read n
if [ $n -eq 1 ]; then
  echo "you choose to Create Table"
  createTable

elif [ $n -eq 2 ]; then
  echo "you choose to list tables"
  ls

elif [ $n -eq 3 ]; then
  echo "You choose to Drop Table"

elif [ $n -eq 4 ]; then
  echo "you choose to Insert into Table"
elif [ $n -eq 5 ]; then
  echo "you choose to Select From Table"
elif [ $n -eq 6 ]; then
  echo "you choose to Delete From Table "
elif [ $n -eq 7 ]; then
  echo "you choose to Update Table"

else
  echo "invalid option"
fi
