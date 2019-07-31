# simply inherit the python 3 image - this image does
# not particularly care what OS runs underneath
FROM python:3

# set an environment variable with the directory
# where we'll be running the app
ENV APP /app

# create the directory and instruct docker to operate
# from there from now on
RUN mkdir $APP
WORKDIR $APP

# expose the port uwsgi will listen on
EXPOSE 5000

# copy the requirements file in order to install
# python dependencies
COPY requirements.txt .

# install python dependencies
RUN pip install -r requirements.txt

# copy the rest of the codebase into the image
COPY . .

# finally, we run uwsgi with the ini file we
# created earlier
CMD [ "uwsgi", "--ini", "app.ini" ]
