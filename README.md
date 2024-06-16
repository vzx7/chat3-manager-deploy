# chat3-manager-deploy
Chat3-manager project deployment script.
Git must be installed on the system.

It is necessary that the directory **/home/$OWN/ENV/.env.production.local** contains a settings file for your backend.

```ini
#/home/$OWN/ENV/.env.production.local
# PORT
PORT = 3000

# TOKENS
TOKEN_SECRET_KEY = your_key
REFRESH_TOKEN_SECRET_KEY = your_key
TOKEN_TIME = 15m,            
REFRESH_TOKEN_TIME = 15d
REFRESH_TOKEN_COOKIES_EXPIRES = 14 # days

# LOG
LOG_FORMAT = dev
LOG_DIR = ../logs

# CORS
ORIGIN = your_host
CREDENTIALS = true

# DATABASE
POSTGRES_USER = root
POSTGRES_PASSWORD = your_password
POSTGRES_HOST = localhost
POSTGRES_PORT = 5432
POSTGRES_DB = dev

# EXTERNAL API
EXTERNAL_API_URL = api_host
EXTERNAL_API_PORT = 4567
EXTERNAL_API_KEY = api_key
```

## Use
### For first time

```bash 
$ git clone git@github.com:vzx7/chat3-manager-deploy.git
$ cd chat3-manager-deploy
$ chmod u+x c3deploy.sh
$ ./c3deploy.sh web www 
```
### For update

```bash 
$ cd chat3-manager-deploy
$ git update
$ ./c3deploy.sh web www 
```

Optionally, you can pass the project owner ($OWN) and the path to the application root ($PART_PATH) where deploy will be executed.
```bash 
$ ./c3deploy.sh web www 
```
That is **/home/$OWN/$PART_PATH**. Default is **/home/$USER/www**
