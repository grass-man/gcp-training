FROM nginx:latest

# nginx will listen on this port
EXPOSE 80

# remove the default config file that
# /etc/nginx/nginx.conf includes
RUN rm /etc/nginx/conf.d/default.conf

# we copy the requirements file in order to install
# python dependencies
COPY app.conf /etc/nginx/conf.d
