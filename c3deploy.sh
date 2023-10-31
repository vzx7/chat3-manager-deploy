#!/usr/bin/env bash
# ENV
DIST=/home/$USER/www
FRONT=/tmp/FRONT

# deploy backend
rm -Rf $DIST
mkdir $DIST
git clone git@github.com:vzx7/chat3-manager-backend.git $DIST --verbose
cd $DIST
npm i
npm run build
# npm run deploy:prod

# deploy frontend
rm -Rf $FRONT
mkdir $FRONT
git clone git@github.com:vzx7/chat3-manager-frontend.git $FRONT --verbose
cd $FRONT
npm i
npm run build
cp -R ./dist/* $DIST/dist/static/

# start app
cd $DIST
# WIP
docker-compose up