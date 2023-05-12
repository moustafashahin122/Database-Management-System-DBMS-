#!/bin/bash

mixedRegex="^([a-z][A-Z])+$"

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
validInput $mixedRegex
m=${input}
echo $m
