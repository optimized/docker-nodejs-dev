FROM node:lts
LABEL maintainer="n@noeljackson.com"
LABEL version=v11.10.0

# set logging to lower level
#ENV NPM_CONFIG_LOGLEVEL notice

# Add packages
ENV PACKAGES="autoconf automake g++ libtool make python git libpng-dev nano vim ca-certificates curl"
RUN apt update && apt-get -y --no-install-recommends install -y ${PACKAGES}

RUN set -eux; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
	gosu nobody true

# Set registry
RUN npm config set registry http://registry.npmjs.org/
RUN npm i -g pm2 yarn lerna

# Login messages
ONBUILD ADD login-message.txt /etc/login-message.txt
RUN echo '[ ! -z "$TERM" -a -r /etc/login-message.txt ] && cat /etc/login-message.txt' >> /etc/bash.bashrc

# Create app directory
RUN mkdir -p /usr/src/app
RUN ls -al /usr/src
WORKDIR /usr/src/app
# Bundle app source
ONBUILD ADD . /usr/src/app

# Start the server by default
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["gosu", "node:node", "/bin/bash"]
