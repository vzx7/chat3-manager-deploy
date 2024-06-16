# chat3-manager-deploy
Chat3-manager project deployment script.
Git must be installed on the system.

It is necessary that the directory **$home/$user/web/$domain/nodeapp/.env.production.local** contains a settings file for your backend.
Where $domain is your domain dir in root project.

```ini
#/$home/$user/web/$domain/nodeapp/.env.production.local
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

## Edit nginx.conf for your domain
```ini
    location / {

        #add redirect if 404
        try_files   $uri @fallback;


        location ~* ^.+\.(css|htm|html|js|json|xml|apng|avif|bmp|cur|gif|ico|jfif|jpg|jpeg|pjp|pjpeg|png|svg|tif|tiff|webp|aac|caf|flac|m4a|midi|mp3|ogg|opus|wav|3gp|av1|avi|m4v|mkv|mov|mpg|mpeg|mp4|mp4v|webm|otf|ttf|woff|woff2|doc|docx|odf|odp|ods|odt|pdf|ppt|pptx|rtf|txt>
            # replace root dir
            root    /home/your_user/path_to_static_dist/;
        }
    }

```