FROM nginx

# install python package
RUN apt-get update && apt-get install -y python python-pip nano

# set an environment variable with the directory
# where we'll be running the app
ENV APP /app

# create the directory and instruct docker to operate
# from there from now on
RUN mkdir $APP
WORKDIR $APP

# copy the requirements file in order to install
# python dependencies
COPY ./requirements.txt .

# install python dependencies
RUN pip install -r requirements.txt

# Remove the default config file that
RUN rm /etc/nginx/conf.d/default.conf

# We copy the requirements file in order to install
# Python dependencies
COPY ./app.conf /etc/nginx/conf.d

# copy the rest of the codebase into the image
COPY ./code .

COPY ./shell.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/shell.sh

# expose the port uwsgi will listen on
EXPOSE 80

# ENTRYPOINT [ "/usr/local/bin/shell.sh" ]
CMD /usr/local/bin/shell.sh