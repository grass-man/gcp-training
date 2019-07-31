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
# get rif of all what we created
gcloud compute instances delete ${INSTANCE_NAME} -q && \
    gcloud source repos delete ${REPOSITORY_NAME} -q && \
    gcloud container images delete ${DOCKER_FLASK_IMAGE} -q && \
    gcloud container images delete ${DOCKER_NGINX_IMAGE} -q

##
##
##                                 888    d8b 888 
##                                 888    Y8P 888 
##                                 888        888 
##       .d88b.  .d8888b  888  888 888888 888 888 
##      d88P"88b 88K      888  888 888    888 888 
##      888  888 "Y8888b. 888  888 888    888 888 
##      Y88b 888      X88 Y88b 888 Y88b.  888 888 
##       "Y88888  88888P'  "Y88888  "Y888 888 888 
##           888                                  
##      Y8b d88P                                  
##       "Y88P"                                  
##                              https://cloud.google.com/storage/docs/how-to 
##
# remove all cloud storage buckets
gsutil rm -r gs://${BUCKET_NAME} && \
    gsutil rm -r $(gsutil ls) && gsutil ls

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
# remove all folders from cloud shell home directory
cd && \
    rm compute-engine-secret.json && \
    cc && ls

# copy app folder to cloud shell home direcvtory
# buld and push docker image to registry
docker build -t gcr.io/order-diamond/super-app .

gcloud container images list && \
    docker push gcr.io/order-diamond/super-app && \
    gcloud container images list

# create compute instance
gcloud beta compute instances create-with-container ${INSTANCE_NAME} \
    --project ${PROJECT_ID} \
    --zone $(gcloud config get-value compute/zone) \
    --machine-type n1-standard-1 \
    --subnet default \
    --network-tier PREMIUM \
    --metadata google-logging-enabled=true \
    --maintenance-policy MIGRATE \
    --service-account ${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com \
    --scopes https://www.googleapis.com/auth/cloud-platform \
    --tags http-server \
    --image cos-stable-75-12105-97-0 \
    --image-project cos-cloud \
    --boot-disk-size 10GB \
    --boot-disk-type pd-standard \
    --boot-disk-device-name ${INSTANCE_NAME} \
    --container-image gcr.io/order-diamond/super-app \
    --container-restart-policy always \
    --container-privileged

# or check through web browser
gcloud compute instances describe ${INSTANCE_NAME} | grep natIP: | cut -d ' ' -f 6

# ssh to created instance
gcloud compute ssh ${INSTANCE_NAME}

# defaults when logged into instance
export PS1="\[\033[01;34m\]ssh\033[01;33m:\[\033[01;34m\]\u@\033[01;33m GCE \t\033[01;34m:\w$\[\033[00m\] "
alias cc='clear' && \
    sudo apt-get -y update && cd && clear

# if everything went well remove whole project from gcp profile
gcloud projects delete ${PROJECT_ID} -q

##      
##
##      8888888b.  8888888888 888888b.   888     888  .d8888b.        .d88888b.  8888888b. 88888888888 8888888 .d88888b.  888b    888  .d8888b.  
##      888  "Y88b 888        888  "88b  888     888 d88P  Y88b      d88P" "Y88b 888   Y88b    888       888  d88P" "Y88b 8888b   888 d88P  Y88b 
##      888    888 888        888  .88P  888     888 888    888      888     888 888    888    888       888  888     888 88888b  888 Y88b.      
##      888    888 8888888    8888888K.  888     888 888             888     888 888   d88P    888       888  888     888 888Y88b 888  "Y888b.   
##      888    888 888        888  "Y88b 888     888 888  88888      888     888 8888888P"     888       888  888     888 888 Y88b888     "Y88b. 
##      888    888 888        888    888 888     888 888    888      888     888 888           888       888  888     888 888  Y88888       "888 
##      888  .d88P 888        888   d88P Y88b. .d88P Y88b  d88P      Y88b. .d88P 888           888       888  Y88b. .d88P 888   Y8888 Y88b  d88P 
##      8888888P"  8888888888 8888888P"   "Y88888P"   "Y8888P88       "Y88888P"  888           888     8888888 "Y88888P"  888    Y888  "Y8888P"  
##                                                                                                                                              
# scp app folder to instance
gcloud compute scp --recurse ~/app ${INSTANCE_NAME}:~

# remove all images from instance
sudo docker rmi -f $(sudo docker images -a -q) && \
    sudo docker-compose rm && cc && \
    printf '=%.0s' {1..100} && echo '' && \
    sudo docker images

# build docker image
sudo docker build -t example .
# run docker image
sudo docker run -p 80:80 example
# run and detach docker image
sudo docker run -d -p 80:80 example
# check assigned ports
sudo netstat -tulpn | grep :80
# check service statuses
sudo service --status-all
# enter docker conatiner
sudo docker exec -it $(sudo docker ps | grep 'example' | awk -e '{print $1}') bash
# stop docker container
sudo docker stop $(sudo docker ps | grep 'example' | awk -e '{print $1}')






