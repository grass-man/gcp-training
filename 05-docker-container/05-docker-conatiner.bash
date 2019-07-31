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
# create apps folder structure
    ##  app/
    ##    nginx/
    ##        app.conf
    ##        Dockerfile
# create yolo container image
mkdir ~/${REPOSITORY_NAME}/app/nginx && \
    cd ~/${REPOSITORY_NAME}/app/nginx && \
    echo "FROM nginx:latest" > Dockerfile && \
    cc && cat Dockerfile
    
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
git commit -m "Raccoon looks for image"
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
# install docker and docker-compose package
sudo apt-get install -y docker.io docker-compose

    # instructions below are instalation sources
    # sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # sudo chmod +x /usr/local/bin/docker-compose

# navigate to source repository folder and merge pull request and navigate to dockerfile
git pull && cd app/nginx

# build, run, validate and stop dokcer container - sudo docker stop IMAGEID
sudo docker build -t ranger-seal .
sudo docker images
sudo docker run -p 80:80 ranger-seal

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
# or check through web browser - image should not be visible due to permission constrains
gcloud compute instances describe ${INSTANCE_NAME} | grep natIP: | cut -d ' ' -f 6


# ONLY IF WE HAVE A TIME TO LOG INTO CONTAINER
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
# detach docker image so it could run in background
sudo docker run -d -p 80:80 ranger-seal

# find running conatiner id
sudo docker ps | grep 'ranger-seal' | awk -e '{print $1}'

# log in to running container
sudo docker exec -it $(sudo docker ps | grep 'ranger-seal' | awk -e '{print $1}') bash

# install pico editor and print out default nginx index file
apt-get update && \
    apt-get install nano && \
    clear && cat /usr/share/nginx/html/index.html

# change default nginx index file with the one from nginx folder
echo '' > /usr/share/nginx/html/index.html && \
    pico /usr/share/nginx/html/index.html

# stop running docker image
sudo docker stop $(sudo docker ps | grep 'ranger-seal' | awk -e '{print $1}')