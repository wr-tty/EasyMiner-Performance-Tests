#!/bin/bash

infoPrefix="INFO:"
errorPrefix="ERROR:"

# rename testing folder to actual time
testFolderInit="../EasyMiner-Performance-Tests/prepared-running-tests"
finalFileName="$(date +%Y-%m-%d_%H-%M-%S)"
testFolderFinal="../EasyMiner-Performance-Tests/finished-tests/$finalFileName"
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

# dump log files
cat /EasyMiner-Performance-Tests/artifacts/results/jmeter.log
cat /EasyMiner-Performance-Tests/artifacts/results/error.jtl
cat /EasyMiner-Performance-Tests/artifacts/results/bzt.log

exit 0
