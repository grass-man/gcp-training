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
# enable google cloud build api service
gcloud services enable cloudbuild.googleapis.com

# create cloud build configuration file
pico ~/${REPOSITORY_NAME}/cloudbuild.yaml

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
# add changes to source repository and wait for new image builds
cd ~/${REPOSITORY_NAME}/
git add .
git commit -m "Raccoon and Weasel are getting automated"
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
# remove source repository folder
sudo rm -rf [CLOUD-SOURCE-REPOSITORY-DIRECTORY]

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
#
# transfer json secret to compute instnace over scp
gcloud compute scp --recurse ~/${REPOSITORY_NAME}/app/docker-compose.yml  ${INSTANCE_NAME}:~

# Go to google cloud build in web console and create build trigger
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
# # build and run docekr compose
# sudo docker-compose up --build

# # remove all images
# sudo docker rmi -f $(sudo docker images -a -q) && cc && \
#     printf '=%.0s' {1..100} && echo '' && \
#     sudo docker images

# # remove all docker-compose images
# sudo docker-compose ps
# sudo docker-compose rm -f

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
# change index file by adding line below
# <h6>Made with <strong style="color: #ff1744">&#10084;</strong></h6>
pico ~/${REPOSITORY_NAME}/app/python/templates/index.html

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
# add changes to source repository and wait for new image builds
git add .
git commit -m "Raccoon and Weasel prepares to be built"
git push origin master

# as docker-compose is not pulling images from registry as workaround pull them by docker command
# CHANGE PROJECT ID BELOW OTHERWISE IT WONT WORK - STORED IN ${PROJECT_ID}
cc && cd . && \
    sudo docker pull gcr.io/[PROJECT_ID]/raccoon && \
    sudo docker pull gcr.io/[PROJECT_ID]/weasel && \
    printf '=%.0s' {1..100} && echo '' && \
    sudo docker images

    # in case you need to tag it
    sudo docker tag gcr.io/[PROJECT_ID]/raccoon raccoon
    sudo docker tag gcr.io/[PROJECT_ID]/weasel weasel

# build and run docekr compose
sudo docker-compose up --build

# or check through web browser - image should not be visible due to permission constrains
gcloud compute instances describe ${INSTANCE_NAME} | grep natIP: | cut -d ' ' -f 6
