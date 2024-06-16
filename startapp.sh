#!/usr/bin/env bash

user=$1
domain=$2
home=$3

#default script name
mainScript="src/index.js"
nodeDir="$home/$user/web/$domain/nodeapp"

if [ ! -d "$nodeDir" ]; then
    mkdir $nodeDir
    chown -R $user:$user $nodeDir
fi


nvmDir="/opt/nvm"
nodeInterpreter="--interpreter /opt/nvm/versions/node/$(cat $nodeDir/.nvm)/bin/node"

#get init script form package.json
package="$nodeDir/package.json"

if [ -e $package ]
then
    mainScript=$(cat $package \
                | grep main \
                | head -1 \
                | awk -F: '{ print $2 }' \
                | sed 's/[",]//g' \
                | sed 's/ *$//g')

    scriptName=$(cat $package \
                | grep name \
                | head -1 \
                | awk -F: '{ print $2 }' \
                | sed 's/[",]//g' \
                | sed 's/ *$//g')
fi

if [ -e  "$nodeDir/app.sock" ]; then
    rm "$nodeDir/app.sock"
    echo "clear processes app.sock"
fi

runuser -l $user -c "pm2 del $scriptName"

envFile=""
# apply enviroment variables from .env file
# !!! Attention, the .env file must not contain comments !!!
if [ -f "$nodeDir/.env" ]; then
    echo ".env file in folder, applying."
    envFile=$(grep -v '^#' $nodeDir/.env | xargs | sed "s/(PORT=(.*) )//g" | sed "s/ = /=/g")
    echo $envFile
fi

#remove blank spaces
pmPath=$(echo "$nodeDir/$mainScript" | tr -d ' ')
runuser -l $user -c "$envFile PORT=$nodeDir/app.sock HOST=127.0.0.1 PWD=$nodeDir NODE_ENV=production pm2 start $pmPath --name $scriptName $nodeInterpreter"

echo "Waiting for init PM2"
sleep 5

if [ ! -f "$nodeDir/app.sock" ]; then
    echo "Allow nginx access to the socket $nodeDir/app.sock"
    chmod 777 "$nodeDir/app.sock"
else
    echo "Sock file not present disable Node app"
    runuser -l $user -c "pm2 del $scriptName"
    rm $nodeDir/app.sock
fi

#copy pm2 logs to app folder
if [ -f "$home/$user/.pm2/logs/$domain-error.log" ]; then
    echo "Copy $home/$user/.pm2/logs/$domain-error.log to nodeapp folder"
    cp -r $home/$user/.pm2/logs/$domain-error.log $nodeDir
fi

if [ -f "$home/$user/.pm2/logs/$domain-out.log" ]; then
    echo "Copy $home/$user/.pm2/logs/$domain-out.log to nodeapp folder"
    cp -r $home/$user/.pm2/logs/$domain-out.log $nodeDir
fi



