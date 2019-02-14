#!/bin/bash

infoPrefix="INFO:"
errorPrefix="ERROR:"

# generate random user for every test run
randNumber=`shuf -i 1-1000 -n1`
email="test$randNumber@easyminer.cz"
pass=`echo ${randNumber} | md5sum | cut -d ' ' -f 1`

# create testing user in EasyMiner
# get api key from response
printf "$infoPrefix Register testing user with credential:\n\tu:$email\n\tp:$pass\n" >&1
apiKey=`curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d "{
\"name\": \"$email\",
\"email\": \"$email\",
\"password\": \"$pass\"
}" $1 | grep apiKey | cut -d ':' -f 2 | sed 's/"//g; s/ //g'`

# copy folder with test templates and replace variable with API key
if [[ -n "$apiKey" ]]
then
    echo "$infoPrefix Response apiKey $apiKey" >&1
    #copy prepared test files to special folder
    testFilesFolder="../EasyMinerTests/prepared-running-tests"
    cp -r ../EasyMinerTests/test-templates-jmx ./${testFilesFolder}/
    echo "$infoPrefix Created folder with template test files in ./$testFilesFolder" >&1

    #replace apikeys variable in taurus test files
    replaceVariable="__apiKeyValue__"
    for filename in ${testFilesFolder}/*.jmx; do
        # filename returns whole path
        echo "$infoPrefix File $filename"
        sed -i -- "s/${replaceVariable}/$apiKey/g" ${filename}
    done
    echo "$infoPrefix Test files are prepared" >&1
    exit 0apiKey
else
    echo "$errorPrefix Response apiKey is null. Is Easy Miner available? Did you try change email?" >&2
    exit 1
fi
