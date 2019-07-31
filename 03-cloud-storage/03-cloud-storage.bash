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
# create a new storage bucket
gsutil mb -p ${PROJECT_ID} -c multi_regional -l eu -b on gs://${BUCKET_NAME}/

    # set the following optional flags to have greater control over the creation of your bucket:
    #   -p: specify the project with which your bucket will be associated.
    #   -c: specify the default storage class of your bucket - multi_regional, regional, nearline, coldline
    #   -l: specify the location of your bucket.
    #   -b: enable Bucket Policy Only for your bucket.

# list available buckets
gsutil ls

# copy files from local machine to cloud storage bucket
gsutil cp bucket.jpg gs://${BUCKET_NAME}/images/

# list all files in bucket
gsutil ls gs://${BUCKET_NAME}/**

# determine bucket size in bytes - remove last 6 digits to get megabytes
gsutil du -s gs://${BUCKET_NAME}/

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
# uncomment index.html file to enable button to view object on bucket
sudo rm /var/www/html/index.html
sudo pico /var/www/html/index.html
curl http://localhost:80

# or check through web browser - image should not be visible due to permission constrains
gcloud compute instances describe ${INSTANCE_NAME} | grep natIP: | cut -d ' ' -f 6

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
# set bucket iam permissions to publicly available
gsutil iam ch allUsers:objectViewer gs://${BUCKET_NAME}/


# remove bucket only if it is empty
gsutil rb gs://${BUCKET_NAME}/

# remove bucket from cloud storage - it will remove also all the objects inside in it
gsutil rm -r gs://${BUCKET_NAME}/