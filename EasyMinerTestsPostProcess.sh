#!/bin/bash

infoPrefix="INFO:"
errorPrefix="ERROR:"

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# rename testing folder to actual time
testFolderInit="$SCRIPTPATH/prepared-running-tests"
finalFileName="$(date +%Y-%m-%d_%H-%M-%S)"
testFolderFinal="$SCRIPTPATH/finished-tests/$finalFileName"
mkdir -p ${testFolderFinal}
# validate last command result
if [[ $? -gt 0 ]]
then
    echo "$errorPrefix Folder \"$testFolderFinal\" already exist. Please rename or delete this folder with prepared test templates." >&1
    exit 1
fi
# rename file to avoid force rewrite
mv "$testFolderInit" ${testFolderFinal}
# print new name to log if command was successful
if [[ $? -eq 0 ]]
then
    echo "infoPrefix Folder \"$testFolderFinal\" renamed to $finalFileName." >&1
fi

exit 0
