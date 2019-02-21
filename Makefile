VERSION := $(shell docker run --rm -it node:lts bash -c "node -v")

.PHONY: push
push: build test
	docker push optimized/docker-nodejs-dev; \
	git add *; \
	git commit -m "Version: $(VERSION)"; \
	git push \

.PHONY: build
build:
	@docker pull node:lts	
	@sed -i -- "s/version=.*/version=$(shell docker run --rm -it node:latest bash -c "node -v")/g" Dockerfile
	@docker build -t optimized/docker-nodejs-dev:latest .
	docker tag optimized/docker-nodejs-dev:latest optimized/docker-nodejs-dev:$(VERSION);

.PHONY: test
test: build
	@docker run --rm -it optimized/docker-nodejs-dev:$(VERSION) bash -c "node -v; yarn -v; cd /tmp; yarn install && echo Test passed; exit;"
	@docker run --rm -it -e CURRENT_UID=$(shell id -u) optimized/docker-nodejs-dev:$(VERSION) bash -c ls
