##      
##      
##      888                        888      
##      888                        888      
##      888                        888      
##      88888b.   8888b.  .d8888b  88888b.  
##      888 "88b     "88b 88K      888 "88b 
##      888  888 .d888888 "Y8888b. 888  888 
##      888 d88P 888  888      X88 888  888 
##      88888P"  "Y888888  88888P' 888  888
##      
##
# remove app folder and upload new app folder
cd ~/${REPOSITORY_NAME} && rm -rf app && cc && ls
   
# create apps folder structure
    ##  app/
    ##    nginx/
    ##        app.conf
    ##        Dockerfile
    ##    python/
    ##        templates/
    ##           index.html
    ##        app.ini
    ##        app.py
    ##        Dockerfile
    ##        requirements.txt
    ##    docker-compose.yml
# DONT FORGET TO CHANGE PROJECT ID IN DOCKER-COMPOSE.YML FILE

##      
##      
##               d8b 888    
##               Y8P 888    
##                   888    
##       .d88b.  888 888888 
##      d88P"88b 888 888    
##      888  888 888 888    
##      Y88b 888 888 Y88b.  
##       "Y88888 888  "Y888 
##           888            
##      Y8b d88P            
##       "Y88P"             
##      
##      
# add changes to source repository
git add .
git commit -m "Raccoon is on one hand with Weasel"
git push origin master

##
##
##                        888      
##                        888      
##                        888      
##      .d8888b  .d8888b  88888b.  
##      88K      88K      888 "88b 
##      "Y8888b. "Y8888b. 888  888 
##           X88      X88 888  888 
##       88888P'  88888P' 888  888 
##
##
# switch to instance where you have logged in via ssh
# navigate to source repository folder and merge pull request and navigate app folder
git pull && cd app

# navigate back to app folder and output container structure and configuration
cc && \
    printf '=%.0s' {1..100} && echo '' && cat python/app.ini && \
    printf '=%.0s' {1..100} && echo '' && cat nginx/app.conf && \
    printf '=%.0s' {1..100} && echo '' && ls -la && \
    printf '=%.0s' {1..100} && echo '' && cat docker-compose.yml && \
    printf '=%.0s' {1..100} && echo ''

# remove all images
sudo docker rmi -f $(sudo docker images -a -q) && cc && \
    printf '=%.0s' {1..100} && echo ''

# double check retrieve all images
sudo docker images

# use docker-compose to build images
sudo docker build -t docker-python ./python
sudo docker build -t docker-nginx ./nginx

# check created images
cc && sudo docker images && \
    printf '=%.0s' {1..100} && echo '' && cat docker-compose.yml && \
    printf '=%.0s' {1..100} && echo ''

# use docker netwrok to access the same functionality as docker-compose
sudo docker container prune -f && \
    sudo docker network create rascalnet && \
    sudo docker run -d --net rascalnet -p 5000:5000 --name raccoon docker-python && \
    sudo docker run -d --net rascalnet -p 80:80 --name weasel docker-nginx

# stop running docker images
sudo docker stop $(sudo docker ps -a -q)
sudo docker network rm $(sudo docker network ls | grep rascalnet | awk -e '{print $1}')

##
##                                                               
##                        888                        888 
##                        888                        888 
##                        888                        888 
##       .d88b.   .d8888b 888  .d88b.  888  888  .d88888 
##      d88P"88b d88P"    888 d88""88b 888  888 d88" 888 
##      888  888 888      888 888  888 888  888 888  888 
##      Y88b 888 Y88b.    888 Y88..88P Y88b 888 Y88b 888 
##       "Y88888  "Y8888P 888  "Y88P"   "Y88888  "Y88888 
##           888                                         
##      Y8b d88P                                         
##       "Y88P"                                         
##
##
# configured docker to use gcloud as a credential helper
gcloud auth configure-docker

# enable google container registry api service
gcloud services enable containerregistry.googleapis.com

# print out image names
cc && \
    printf '=%.0s' {1..100} && echo '' && \
    echo "PYTHON-IMAGE: " ${DOCKER_FLASK_IMAGE} && \
    echo "NGINX-IMAGE: " ${DOCKER_NGINX_IMAGE} && \
    printf '=%.0s' {1..100} && echo ''

# navigate to source repository folder and build both images
cd ~/${REPOSITORY_NAME}/app && \
    docker build -t ${DOCKER_FLASK_IMAGE} ./python && \
    docker build -t ${DOCKER_NGINX_IMAGE} ./nginx && \
    printf '=%.0s' {1..100} && echo '' && docker images

# push docker images to google container registry
gcloud container images list && \
    docker push ${DOCKER_FLASK_IMAGE} && \
    docker push  ${DOCKER_NGINX_IMAGE} && \
    gcloud container images list

    # delete container images if needed
    gcloud container images delete ${DOCKER_FLASK_IMAGE}
    gcloud container images delete ${DOCKER_NGINX_IMAGE}

# create service account key
cd && gcloud iam service-accounts keys create compute-engine-secret.json \
    --iam-account ${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com \
    --key-file-type json

# transfer json secret to compute instnace over scp
gcloud compute scp --recurse compute-engine-secret.json  ${INSTANCE_NAME}:~

# update docker-compose.yaml file
cc && ls

# remove build tag and edit image tag with conatiner registry url
pico ~/${REPOSITORY_NAME}/app/docker-compose.yml

##      
##      
##               d8b 888    
##               Y8P 888    
##                   888    
##       .d88b.  888 888888 
##      d88P"88b 888 888    
##      888  888 888 888    
##      Y88b 888 888 Y88b.  
##       "Y88888 888  "Y888 
##           888            
##      Y8b d88P            
##       "Y88P"             
##      
##      
# add changes to source repository
git add .
git commit -m "Raccoon and Weasel lives in cloud"
git push origin master

##
##
##                        888      
##                        888      
##                        888      
##      .d8888b  .d8888b  88888b.  
##      88K      88K      888 "88b 
##      "Y8888b. "Y8888b. 888  888 
##           X88      X88 888  888 
##       88888P'  88888P' 888  888 
##
##
# switch to instance where you have logged in via ssh
# authorize to cloud container registry
gcloud auth configure-docker
cat ~/compute-engine-secret.json | sudo docker login -u _json_key --password-stdin https://gcr.io

# navigate to source repository folder and merge pull request and navigate app folder
git pull && cd app

# remove all images
sudo docker rmi -f $(sudo docker images -a -q) && \
    sudo docker-compose rm && cc && \
    printf '=%.0s' {1..100} && echo '' && \
    sudo docker images

# as docker-compose is not pulling images from registry as workaround pull them by docker command
# DONT FORGET TO CHANGE PROJECT ID TO CURRENT ONE
cc && cd . && \
    sudo docker pull gcr.io/[PROJECT_ID]/raccoon && \
    sudo docker pull gcr.io/[PROJECT_ID]/weasel

# build and run docekr compose
sudo docker-compose up --build
    # in case docker-compose up return no such image use
    sudo docker-compose ps
    # if found something remove all images
    sudo docker-compose rm

# as docker-compose is not pulling images from registry as workaround pull them by docker command
# cc && cd . && \
#     sudo docker tag gcr.io/[PROJECT_ID]/raccoon raccoon && \
#     sudo docker tag gcr.io/[PROJECT_ID]/weasel weasel && \
#     printf '=%.0s' {1..100} && echo '' && \
#     sudo docker images