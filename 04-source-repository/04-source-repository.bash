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
# create apps folder structure
    ##  app/
    ##    python/
    ##        main.py
    ##        requirements.txt
    ##        app.ini
    ##        templates/
    ##          index.htm
# transfer application to compute instnace over scp
# gcloud compute scp --recurse ~/app ${INSTANCE_NAME}:~

# switch to instance where you have logged in via ssh
# install pip - pyhton packahe manager
sudo apt-get install -y \
    python-setuptools \
    build-essential \
    python \
    python-dev \
    git \
    python-pip

# # install python libraries
# cd ~/app/python && sudo pip install -r requirements.txt

# # run server using uwsgi gateway
# sudo uwsgi app.ini
#     # run netstat to get running instance on specific port number in order to stop it
#     sudo netstat -tulpn | grep :80
#     # check runnign and available services
#     sudo service --status-all
#     # if not working stop apache webserver
#     sudo service apache2 stop

# # remove all files and continue with source repository
# cd && rm -rf app && cc

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
# enable google source repository api service
gcloud services enable sourcerepo.googleapis.com

# create source repository
gcloud source repos create ${REPOSITORY_NAME}

# lis all repositories
gcloud source repos list

# clone source repository
gcloud source repos clone ${REPOSITORY_NAME}

# move app files to source repository folder
mv app ${REPOSITORY_NAME} && cd ${REPOSITORY_NAME}

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
# add files to source repository
git add .
git commit -m "Raccoon has crawled into cloud"
git push origin master

# get source repository url for git clone command
gcloud source repos describe ${REPOSITORY_NAME} | grep url: | cut -d ' ' -f 2

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
# might be that you need to execute credentials shell script to avoid manual authorization
# clone project from source repository and run it
git clone https://source.developers.google.com/p/black-old-rhino/r/black-old-rhino-repository

# install python libraries
cd app/python && sudo pip install -r requirements.txt

# run server using uwsgi gateway
sudo uwsgi app.ini

# check assigned ports
sudo netstat -tulpn | grep :80
# check service statuses
sudo service --status-all