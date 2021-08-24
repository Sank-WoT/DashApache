############################################################
# Dockerfile to build Flask App
# Based on
############################################################

# Set the base image
FROM debian:latest

# File Author / Maintainer
MAINTAINER Serobabov Aleksander

RUN apt-get update && apt-get install -y apache2
RUN apt-get install -y libapache2-mod-wsgi-py3 
RUN apt-get install -y build-essential 
RUN apt-get install -y python3 
RUN apt-get install -y git
RUN apt-get install -y python3-pip
RUN apt-get install -y vim \
 && apt-get clean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

# Copy over and install the requirements

RUN git clone https://Sank-WoT:1995rapSank@github.com/Sank-WoT/DashExample.git
RUN pip3 install -r /var/www/apache-flask/app/requirements.txt

# Copy over the apache configuration file and enable the site
#COPY ./apache-flask.conf /etc/apache2/sites-available/apache-flask.conf
RUN cp DashExample/apache-flask.conf /etc/apache2/sites-available/apache-flask.conf
RUN a2ensite apache-flask
RUN a2enmod headers

# Copy over the wsgi file
#COPY ./apache-flask.wsgi /var/www/apache-flask/apache-flask.wsgi
RUN cp DashExample/apache-flask.conf /etc/apache2/sites-available/apache-flask.conf

RUN cp DashExample/run.py /var/www/apache-flask/run.py
RUN cp DashExample/dashapp.py /var/www/apache-flask/dashapp.py
RUN cp DashExample/app /var/www/apache-flask/app/
#COPY ./run.py /var/www/apache-flask/run.py
#COPY ./dashapp.py /var/www/apache-flask/dashapp.py
#COPY ./app /var/www/apache-flask/app/

RUN a2dissite 000-default.conf
RUN a2ensite apache-flask.conf

# LINK apache config to docker logs.
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log


EXPOSE 80

WORKDIR /var/www/apache-flask

CMD  /usr/sbin/apache2ctl -D FOREGROUND
