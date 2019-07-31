##
##
##     8888888b.            .d888                  888 888            
##     888  "Y88b          d88P"                   888 888            
##     888    888          888                     888 888            
##     888    888  .d88b.  888888 8888b.  888  888 888 888888 .d8888b 
##     888    888 d8P  Y8b 888       "88b 888  888 888 888    88K     
##     888    888 88888888 888   .d888888 888  888 888 888    "Y8888b.
##     888  .d88P Y8b.     888   888  888 Y88b 888 888 Y88b.       X88
##     8888888P"   "Y8888  888   "Y888888  "Y88888 888  "Y888  88888P'
## 
##
# fresh new start - list all available projects
gcloud projects list

# edit and load .bashrc file environment variables
pico .bashrc && source .bashrc

# set cloud shell defaults
defaults

# create project
gcloud projects create ${PROJECT_ID} \
    --name "My Hello World Project" \
    --labels type=happy

# link created project to billing account
gcloud beta billing projects link ${PROJECT_ID} \
    --billing-account $(gcloud beta billing accounts list | tail -n+2 | awk '{print $1}')

# run custom startup function
startup