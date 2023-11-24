#!/usr/bin/env bash

# ENV DEFAULT
OWN=$USER
PART_PATH=www

# set OWN
if [ "$1" != "" -a -d "/home/$1" ] ; then 
    OWN=$1
fi
# set PART_PATH
if [ "$2" != "" -a -d "/home/$OWN/$2" ] ; then 
    PART_PATH=$2
fi

# ENV MIX
BACK_DIR=/home/$OWN/$PART_PATH
BACK_DIST_DIR=$BACK_DIR/dist
FRONT_DIR=$BACK_DIR/dist/static
TMP_BACK=/tmp/BACK
TMP_FRONT=/tmp/FRONT
SETTINGS_DIR=/home/$OWN/ENV

# functions
function startapp {
    echo "Start app..."
    chown -R $OWN:$OWN $BACK_DIR
    cd ~/chat3-manager-deploy
    ./startapp.sh manager manager.chat3.generem.ru /home
}

function build_back {
    rm -Rf $TMP_BACK
    mkdir $TMP_BACK
    git clone git@github.com:vzx7/chat3-manager-backend.git $TMP_BACK --verbose
    cd $TMP_BACK
    npm i
    npm run build:tsc
}

function cp_back {
    cp -R dist/* $BACK_DIST_DIR
    cp -R node_modules $BACK_DIR
    cp ecosystem.config.js package.json $BACK_DIR
}

function install_back {
    if [ -d $BACK_DIST_DIR ] ; then
        cp_back
    else 
        mkdir $BACK_DIST_DIR
        cp_back
    fi
}

function deploy_back () {
    echo "Deploing backend to $BACK_DIST_DIR..."
    build_back
    install_back
    cp $SETTINGS_DIR/.nvm $SETTINGS_DIR/.env.production.local $BACK_DIR
    cd $BACK_DIR
    mkdir logs
    touch logs/access.log
    touch logs/error.log
}


function update_back {
    echo "Update backend..."
    build_back
    install_back
}

function install_front {
    echo "Instal frontend."
    cp -R ./dist/* $FRONT_DIR
    echo -e "Done."
}

function deploy_front {
    echo "Deploing frontend to $FRONT_DIR..."
    rm -Rf $TMP_FRONT
    mkdir $TMP_FRONT
    git clone git@github.com:vzx7/chat3-manager-frontend.git $TMP_FRONT --verbose
    cd $TMP_FRONT
    npm i
    npm run build
    echo "Clear frontend location."
    
    if [ -d $FRONT_DIR ] ; then
        install_front
    else
        cd $BACK_DIST_DIR
        mkdir static
        cd $TMP_FRONT
        install_front
    fi
}

function update_front {
    if [ -d $BACK_DIR ] ; then
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
    deploy_back
    deploy_front
}

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
