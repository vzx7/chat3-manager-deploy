#!/usr/bin/env bash

# ENV
BACK=/home/$USER/www
TMP_BACK=/tmp/BACK
FRONT=/tmp/FRONT
IS_BACK_DEPLOYED=0

# functions
function startapp {
    echo -n "Start app..."
    cd $BACK
    # TODO реализовать старт|рестарт приложения
    # pm2 start
    echo
}

function clear {
    echo
    echo -n "Clear location..."
    rm -Rf $BACK
    mkdir $BACK
}

function deployback () {
    clear
    echo
    echo "Update for backend..."
    git clone git@github.com:vzx7/chat3-manager-backend.git $BACK --verbose
    cd $BACK
    npm i
    npm run build
    IS_BACK_DEPLOYED=1
}


function update_back {
    echo
    echo "Update for backend..."
    rm -Rf $TMP_BACK
    mkdir $TMP_BACK
    cd $TMP_BACK
    git clone git@github.com:vzx7/chat3-manager-backend.git $TMP_BACK --verbose
    npm i
    npm run build
    rm -Rf $BACK/dist/
    cp -R ./dist/ $BACK/
    IS_BACK_DEPLOYED=1
}

function update_front {
    # TODO Проверить что back развернут
    if [ $IS_BACK_DEPLOYED -eq 0 ] ; then
        echo -n "You must first deploy the backend!"
        echo
        echo -n "Do you want to deploy the backend and update the frontend?"
        echo
        echo -n "Select one: (yes|no): "
        read -r answer
        if [ "$answer" = "no" ] ; then
            echo;
            echo "Ok, good bye!"
            exit 0
        else
            clear
            deployback
            echo "Backend deployed!"
        fi
    fi
    echo
    echo "Update for frontend..."
    rm -Rf $FRONT
    mkdir $FRONT
    git clone git@github.com:vzx7/chat3-manager-frontend.git $FRONT --verbose
    cd $FRONT
    npm i
    npm run build
    cp -R ./dist/* $BACK/dist/static/
}

function full_update {
    update_back
    update_front
}

function deploy {
    clear
    deployback
    update_front
}

# start script
echo
echo -n "How do you want to do?"
echo
echo -n "Select level: (deploy = 0 | full update = 1 | front update = 2 | back update = 3): "
read -r answer

if [ $answer = 3 ] ; then
    update_back
elif [ $answer = 2 ] ; then
    update_front
elif [ $answer = 1 ] ; then
    full_update
elif [ $answer = 0 ] ; then
    deploy
else
    echo
    echo "Bad selection"
    echo "Good bye!"
fi

startapp
exit 0;
