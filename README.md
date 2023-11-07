# chat3-manager-deploy
Chat3-manager project deployment script.
Git must be installed on the system.

It is necessary that the directory **/home/$OWN/ENV/.env.production.local** contains a settings file for your backend.

```ini
#/home/$OWN/ENV/.env.production.local
# PORT
PORT = 3030

# TOKEN
SECRET_KEY = asdfadf

# LOG
LOG_FORMAT = combined
LOG_DIR = ../logs

# CORS
ORIGIN = your.domain.com
CREDENTIALS = true

# DATABASE
POSTGRES_USER = root
POSTGRES_PASSWORD = asdfasdf
POSTGRES_HOST = localhost
POSTGRES_PORT = 5432
POSTGRES_DB = prod
```

Use:
```bash 
$ git clone git@github.com:vzx7/chat3-manager-deploy.git
$ cd chat3-manager-deploy
$ chmod u+x c3deploy.sh
$ ./c3deploy.sh www
```

Optionally, you can pass the project owner ($OWN) and the path to the application root ($PART_PATH) where deploy will be executed.
```bash 
$ ./c3deploy.sh web www 
```
That is **/home/$OWN/$PART_PATH**. Default is **/home/$USER/www**