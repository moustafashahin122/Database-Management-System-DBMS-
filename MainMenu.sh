#!/bin/bash

function mainMenu {

    cd ${scriptDir}
    echo " ***********************************"

    echo "DBMS MAIN MENU"
    echo "select the operation "
    echo "  1) Create database"
    echo "  2) List Databases"
    echo "  3) connect to database"
    echo "  4) Drop database"
    read -r n
    echo " ***********************************"

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
    else
        echo " please choose one of the menu"
        mainMenu
    fi
}

function createDB {
    echo " please enter a name for the database"
    validInput "${mixedRegex}"

    dbName="${input}"

    if ! [ -d "${databasesDir}"/"${dbName}" ]; then
        mkdir -p "${databasesDir}"/"${dbName}"
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
    echo " ***********************************"

    if [ -d "${databasesDir}"/"${dbName}" ]; then
        currentDB="${databasesDir}"/"${dbName}"

        echo " you're connected to ${dbName}"
        tablesMenu
    else
        echo "no database with such name"
    fi

}

function listDBs {

    cd "${databasesDir}"
    ls
}
function dropDB {
    echo "you choose to drop database"
    listDBs
    echo "Enter a databse name to delete "
    read -r dbDelete
    if [ -d "${databasesDir}"/"${dbDelete}" ]; then
        rm -r "${databasesDir}"/"${dbDelete}"
        echo "${dbDelete}" deleted successfully
    else
        echo "Database is not exist"
    fi
}
