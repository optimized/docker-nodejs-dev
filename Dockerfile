FROM node:latest
LABEL maintainer="n@noeljackson.com"
LABEL version=v11.9.0
USER root
ONBUILD ADD login-message.txt /etc/login-message.txt
RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc
ONBUILD RUN cat /etc/login-message.txt > /etc/motd

# set logging to lower level
#ENV NPM_CONFIG_LOGLEVEL notice

# Add packages
ENV PACKAGES="autoconf automake g++ libtool make python git libpng-dev"
RUN apt install -y ${PACKAGES}

# Set registry
RUN npm config set registry http://registry.npmjs.org/
RUN npm i -g pm2 yarn

# Create app directory
RUN mkdir -p /usr/src/app/node_modules && chown -R node:node /usr/src/app/
WORKDIR /usr/src/app

# Setup node_modules to be shareable
VOLUME ["/usr/src/app/node_modules"]
USER node

# Bundle app source
ONBUILD ADD . /usr/src/app/

# Start the server by default
CMD ["yarn", "start"]
