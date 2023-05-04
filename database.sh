#!/bin/bash 


echo "DBMS MAIN MENU";

echo "select the operation ***********"
echo "  1) Create database"
echo "  2) List Databases"
echo "  3) connect to database"
echo "  4)Drop database" 

read n
  if [ $n -eq 1 ]
  then
 echo "you choose to create a new database" 
  read -p "enter the Database name " dbName 
  mkdir $dbName 
   elif [ $n -eq 2 ]
  then
   echo "you choose to list database"
  ls 
  
   elif [ $n -eq 3 ]
  then
  echo "You choose to connect to database"
  read -p "enter a data base name to connect " dbConnect
   cd $dbConnect 
   elif [ $n -eq 4 ]
  then
   echo "you choose to drop database"
  read -p "Enter a databse name to delete " dbDelete
  if [ -d $dbDelete ]
   then rmdir  $dbDelete 
   else 
   echo "Database is not exist"
   fi
  else 
   echo "invalid option"
  fi




##read n
##case $n in
  ##1) echo "you choose to create a new database" 
  ##read -p "enter the Database name " dbName 
  ##mkdir $dbName 
  ##;;
  ##2) echo "you choose to list database"
  ##ls 
  ##;;
  ##3) echo "You choose to connect to database"
  ##read dbConnect
  ##cd $dbConnect 
  ##;;
  ##4) echo "you choose to drop database"
  ##read -p "Enter a databse name to delete " dbDelete 
  ##rmdir  $dbDelete
  ##;;
  ##*) echo "invalid option"
  ##;;
##esac
