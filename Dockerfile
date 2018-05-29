FROM node:10.2.1-alpine
LABEL maintainer="n@noeljackson.com"

# The official image has verbose logging; change it to npm's default
ENV NPM_CONFIG_LOGLEVEL notice

# Add packages
ENV PACKAGES="libpng-dev python make g++"
RUN apk add --no-cache $PACKAGES

# Add temporary packages, and build the NPM packages/binaries
ENV EPHEMERAL_PACKAGES="autoconf automake g++ libtool make nasm python python-dev git"
RUN apk add --no-cache --virtual .tmp $EPHEMERAL_PACKAGES \
  && apk del .tmp

# Set registry
RUN npm config set registry http://registry.npmjs.org/

# Create app directory
ONBUILD RUN mkdir -p /usr/src/app
ONBUILD WORKDIR /usr/src/app
# Install app dependencies (package.json)

ONBUILD ADD package*.json /usr/src/app/
# Install the app
ONBUILD RUN npm i
# Add PM2, for Node process management
RUN npm i -g pm2

# Bundle app source
ONBUILD ADD . /usr/src/app/
#ONBUILD RUN cp -a /tmp/node_modules /usr/src/app/

ONBUILD ARG NODE_ENV
ONBUILD ENV NODE_ENV $NODE_ENV
ONBUILD ARG API_HOST
ONBUILD ENV API_HOST $API_HOST
ONBUILD ARG CLIENT_HOST
ONBUILD ENV CLIENT_HOST $CLIENT_HOST
ONBUILD ARG HOST
ONBUILD ENV HOST $HOST
ONBUILD ARG PORT
ONBUILD ENV PORT $PORT

# Build distribution
ONBUILD RUN npm run clean
ONBUILD RUN npm run build

# Start the server by default
CMD pm2-docker start dist/server.js -i max
