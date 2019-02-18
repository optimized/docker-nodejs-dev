FROM node:lts
LABEL maintainer="n@noeljackson.com"
LABEL version=v11.9.0

# set logging to lower level
#ENV NPM_CONFIG_LOGLEVEL notice

# Add packages
ENV PACKAGES="autoconf automake g++ libtool make python git libpng-dev"
RUN apt install -y ${PACKAGES}

# Set registry
RUN npm config set registry http://registry.npmjs.org/
RUN npm i -g pm2 yarn

# Login messages
ONBUILD ADD login-message.txt /etc/login-message.txt
RUN echo '[ ! -z "$TERM" -a -r /etc/login-message.txt ] && cat /etc/login-message.txt' >> /etc/bash.bashrc

# Create app directory
WORKDIR /usr/src/app

# Bundle app source
ONBUILD ADD . /usr/src/app/

# Start the server by default
CMD ["yarn", "start"]
