FROM debian:testing-slim
LABEL maintainer="n@noeljackson.com"
RUN echo "Node.js that serves your app from /usr/src/app, hopefully useful in production and development, use the \`packages=your list of packages\` argument to specify packages. Default is \`packages='build-essential dh-autoreconf curl xz-utils python libpng-dev git'\`"

# Install packages
ARG PACKAGES="build-essential dh-autoreconf curl xz-utils python libpng-dev git"
RUN apt-get update \
  && apt-get install -y apt-utils \
  && apt-get install -y ${PACKAGES} \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs \
# Clean up apt things you don't really need for production
  && apt-get clean \
  ; apt-get autoclean \
  ; echo -n > /var/lib/apt/extended_states \
  ; rm -rf /var/lib/apt/lists/* \
  ; rm -rf /usr/share/man/?? \
  ; rm -rf /usr/share/man/??_*

# Set registry
RUN npm config set registry http://registry.npmjs.org/

# Install yarn
RUN npm i -g yarn

# Install app dependencies (package.json)
ONBUILD WORKDIR /tmp
ONBUILD COPY package.json /tmp/

# Install the app
ONBUILD RUN npm install

# Create app directory
ONBUILD RUN mkdir -p /usr/src/app
ONBUILD WORKDIR /usr/src/app

# Bundle app source
ONBUILD COPY . /usr/src/app
ONBUILD RUN cp -a /tmp/node_modules /usr/src/app/

# Build distribution
ONBUILD RUN npm run clean && npm run build

# Start the server by default
CMD npm run server
