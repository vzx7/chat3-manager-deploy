#!/usr/bin/env bash

# ENV
BACK_DIR=/home/$USER/$1
FRONT_DIR=$BACK_DIR/dist/static
TMP_BACK=/tmp/BACK
TMP_FRONT=/tmp/FRONT
ENV_FILE=/home/$USER/ENV/.env.production.local

# functions
function startapp {
    echo "Start app..."
    cd $BACK_DIR
    # TODO реализовать старт|рестарт приложения
    # pm2 start
    echo
}

function clear {
    echo
    echo "Clear location..."
    rm -Rf $BACK_DIR
    mkdir $BACK_DIR
}

function deploy_back () {
    echo "Deploing backend..."
    git clone git@github.com:vzx7/chat3-manager-backend.git $BACK_DIR --verbose
    cd $BACK_DIR
    npm i
    npm run build
    cp $ENV_FILE .
}


function update_back {
    echo
    echo "Update backend..."
    rm -Rf $TMP_BACK
    mkdir $TMP_BACK
    cd $TMP_BACK
    git clone git@github.com:vzx7/chat3-manager-backend.git $TMP_BACK --verbose
    npm i
    npm run build
    rm -Rf $BACK_DIR/dist/
    cp -R ./dist/ $BACK_DIR/
}

function deploy_front {
    echo
    echo "Deploing frontend..."
    rm -Rf $TMP_FRONT
    mkdir $TMP_FRONT
    git clone git@github.com:vzx7/chat3-manager-frontend.git $TMP_FRONT --verbose
    cd $TMP_FRONT
    npm i
    npm run build
    echo "Clear frontend location."
    rm -Rf $FRONT_DIR
    mkdir $FRONT_DIR
    echo "Instal frontend."
    cp -R ./dist/* $FRONT_DIR
    echo -e "Done."
}

function update_front {
    if [ -d $FRONT_DIR ] ; then
        deploy_front
    else
        echo "You must first deploy the backend!"
        echo "Do you want to deploy the backend and update the frontend?"
        echo -n "Select one: (yes|no): "
        read -r answer
        if [ "$answer" == "no" ] ; then
            echo -e "\nOk, good bye!"
            exit 1
        else
            clear
            deploy_back
            echo -e "\nBackend deployed!"
            deploy_front
        fi
    fi
}

function full_update {
    update_back
    update_front
}

function deploy {
    clear
    deploy_back
    deploy_front
}

# start script
if [ "$1" = "" ] ; then 
echo -e "*********************\nYou must pass the path where the project is located as the first argument
For example:\n 
./c3deploy.sh www\n
This will mean that the directory is located along the path: /home/\$USER/www.
*********************"
exit 1
fi

echo "How do you want to do?"
echo -e "\nSelect level: \n\n- deploy = 0 \n- full update = 1 \n- front update = 2 \n- back update = 3"
echo -n ">: "
read -r answer

if [ $answer -eq 3 ] ; then
    update_back
elif [ $answer -eq 2 ] ; then
    update_front
elif [ $answer -eq 1 ] ; then
    full_update
elif [ $answer -eq 0 ] ; then
    deploy
else
    echo -e "\nBad selection"
    echo -e "\nGood bye!"
    exit 1
fi

startapp
exit 0
