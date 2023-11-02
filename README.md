# chat3-manager-deploy
Chat3-manager project deployment script.
Git must be installed on the system.
Use:
```bash 
$ git clone git@github.com:vzx7/chat3-manager-deploy.git
$ cd chat3-manager-deploy
$ chmod u+x c3deploy.sh
$ ./c3deploy.sh www
```

The first argument to the script must be the location of your project relative to the $USER directory.
```bash 
$ ./c3deploy.sh www
```
That is **/home/$USER/www**.