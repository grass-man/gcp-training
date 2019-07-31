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
# get service account details when created
gcloud iam service-accounts list

# create new account if does not exists - command below will create an empty service account
# for more information visit - https://cloud.google.com/iam/docs/granting-roles-to-service-accounts
gcloud iam service-accounts create ${SERVICE_ACCOUNT} --display-name "Compute Engine service account"

# add role to service account
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member serviceAccount:${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/editor

# look for service account details step by step, build whole terminal commmand
gcloud iam service-accounts describe $(gcloud iam service-accounts list | grep ${SERVICE_ACCOUNT} | awk '{print $5}')

# enable google compute engine api service
gcloud services enable compute.googleapis.com

# create compute instance
gcloud compute instances create ${INSTANCE_NAME} \
    --project ${PROJECT_ID} \
    --zone $(gcloud config get-value compute/zone) \
    --machine-type n1-standard-1 \
    --subnet default \
    --network-tier PREMIUM \
    --maintenance-policy MIGRATE \
    --service-account ${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com \
    --scopes storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/trace.append,cloud-platform,https://www.googleapis.com/auth/cloud_debugger \
    --tags http-server,https-server,python-webserver \
    --image ubuntu-1804-bionic-v20190628 \
    --image-project ubuntu-os-cloud \
    --boot-disk-size 10GB \
    --boot-disk-type pd-standard \
    --boot-disk-device-name  ${INSTANCE_NAME}

# check available firwall rules in various output formats yaml or json
gcloud compute firewall-rules list \
    --format yaml | grep name:

# create firewall for python webserver with tcp port 5000
gcloud compute firewall-rules create default-python-webserver \
    --project ${PROJECT_ID} \
    --direction INGRESS \
    --priority 1000 \
    --network default \
    --action ALLOW \
    --rules tcp:5000 \
    --source-ranges 0.0.0.0/0 \
    --target-tags python-webserver

# if this is new project and first instance - http and https tags must eb created as well
gcloud compute firewall-rules create default-allow-http \
    --project ${PROJECT_ID} \
    --direction INGRESS \
    --priority 1000 \
    --network default \
    --action ALLOW \
    --rules tcp:80 \
    --source-ranges 0.0.0.0/0 \
    --target-tags http-server

gcloud compute firewall-rules create default-allow-https \
    --project ${PROJECT_ID} \
    --direction INGRESS \
    --priority 1000 \
    --network default \
    --action ALLOW \
    --rules tcp:443 \
    --source-ranges 0.0.0.0/0 \
    --target-tags https-server

# check available firwall rules in various output formats yaml or json
gcloud compute firewall-rules list \
    --format yaml | grep name:

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
# ssh to created instance
gcloud compute ssh ${INSTANCE_NAME}

# defaults when logged into instance
export PS1="\[\033[01;34m\]ssh\033[01;33m:\[\033[01;34m\]\u@\033[01;33m GCE \t\033[01;34m:\w$\[\033[00m\] "
alias cc='clear' && \
    sudo apt-get -y update && cd && clear

#install apache webserver
sudo apt-get install -y apache2

# create index.html file and store it in apache html directory
echo 'Hello <strong>Revenue</strong>' | sudo tee /var/www/html/index.html
curl http://localhost:80

# create warm welcoming webpage
sudo pico /var/www/html/index.html

# check through web browser using this ip
gcloud compute instances describe ${INSTANCE_NAME} | grep natIP: | cut -d ' ' -f 6
