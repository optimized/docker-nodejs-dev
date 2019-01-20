.PHONY: push
push: build test
	export buildversion=$(shell docker run --rm -it optimized/docker-nodejs-dev:latest bash -c "node -v"); \
	docker tag optimized/docker-nodejs-dev:latest optimized/docker-nodejs-dev:"$$buildversion"; \
	docker push optimized/docker-nodejs-dev; \
	git add *; \
	git commit -m "Version: $$buildversion"; \
	git push

.PHONY: build
build:
	docker pull node:latest	
	sed -i -- "s/version=.*/version=$(shell docker run --rm -it node:latest bash -c "node -v")/g" Dockerfile
	docker build -t optimized/docker-nodejs-dev:latest .

.PHONY: test
test: build
	@docker run --rm -it optimized/docker-nodejs-dev bash -c "node -v; yarn -v; yarn install && echo Test passed; exit;"
