function defaults(){
    alias cc='clear'
    PROJECT_ID="night-owl"
    SERVICE_ACCOUNT="google-compute-engine"
    INSTANCE_NAME="${PROJECT_ID}-instance"
    BUCKET_NAME="${PROJECT_ID}-bucket"
    REPOSITORY_NAME="${PROJECT_ID}-repository"
    DOCKER_FLASK_IMAGE="gcr.io/${PROJECT_ID}/raccoon"
    DOCKER_NGINX_IMAGE="gcr.io/${PROJECT_ID}/weasel"

    PS1="\[\033[01;32m\]\u@\033[01;33m\${PROJECT_ID} \t\033[01;32m:\w$\[\033[00m\] "

    printf "\n"
    printf "PROJECT_ID:         ${PROJECT_ID}\n"
    printf "SERVICE_ACCOUNT:    ${SERVICE_ACCOUNT}\n"
    printf "INSTANCE_NAME:      ${INSTANCE_NAME}\n"
    printf "BUCKET_NAME:        ${BUCKET_NAME}\n"
    printf "REPOSITORY_NAME:    ${REPOSITORY_NAME}\n"
    printf "DOCKER_FLASK_IMAGE: ${DOCKER_FLASK_IMAGE}\n"
    printf "DOCKER_NGINX_IMAGE: ${DOCKER_NGINX_IMAGE}\n"
    printf "\n"
}

function startup() {

    if [ "$(gcloud projects list | head -n 2 | tail -n+2 | cut -d ' ' -f 1)" == ${PROJECT_ID} ] && [ ${PROJECT_ID} != "" ]; then
        gcloud config set project $(gcloud projects list | head -n 2 | tail -n+2 | cut -d ' ' -f 1) && \
            gcloud config set functions/region europe-west2 && \
            gcloud config set compute/region europe-west && \
            gcloud config set compute/zone europe-north1-a;
    else
        echo "Please create new project";
    fi

    gcloud config set survey/disable_prompts true
    sudo gcloud components update
}