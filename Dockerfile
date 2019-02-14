FROM node:latest
LABEL maintainer="n@noeljackson.com"
LABEL version=v11.9.0
USER root
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
RUN mkdir -p /usr/src/app && chown -R $(id -u node):$(id -g node) /usr/src/app
WORKDIR /usr/src/app
USER node

# Bundle app source
ONBUILD ADD . /usr/src/app/

# Install the app
ONBUILD RUN yarn clean
ONBUILD RUN yarn i

# Start the server by default
CMD ["yarn", "start"]
