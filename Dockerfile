FROM node:latest
LABEL maintainer="n@noeljackson.com"
LABEL version=v11.8.0

# The official image has verbose logging; change it to npm's default
#ENV NPM_CONFIG_LOGLEVEL notice

# Add packages
ENV PACKAGES="autoconf automake g++ libtool make python git libpng-dev"
RUN apt install -y ${PACKAGES}

# Set registry
RUN npm config set registry http://registry.npmjs.org/
RUN npm i -g pm2 yarn

RUN bash -c "echo 'To start run: yarn start' > /etc/motd"

# Create app directory
ONBUILD RUN mkdir -p /usr/src/app
ONBUILD WORKDIR /usr/src/app

# Bundle app source
ONBUILD ADD . /usr/src/app/

# Install the app
ONBUILD RUN yarn clean
ONBUILD RUN yarn i

# Start the server by default
CMD ["yarn", "start"]
