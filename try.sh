#!/bin/bash
# mixedRegex to validate filesname to be at least 3 charaters and doesn't start with a number and doesn't contain and special character
mixedRegex="^[a-zA-Z][a-zA-Z0-9]{2,}$"
#regex to validate number of columns
numRegex="^[1-9]+$"
strRegex="^[a-zA-Z]+$"
#to make sure user input for menus is numbers
numRegexy="^[0-9]+$"
#validate col name to be at least 2 char with no numbers
colNameRegex="^[a-zA-Z]{2,}$"
#validate data to be inserted into table to be at least on char

insertRegex="^[a-zA-Z0-9]+$"
function numOrStr {
    output="not valid"
    if [[ $1 =~ ${numRegexy} ]]; then
        output="num"

    elif [[ $1 =~ ${strRegex} ]]; then
        output="string"

    fi

}

numOrStr 12d3
echo $output
