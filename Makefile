.PHONY: build
build:
	docker build -t optimized/docker-nodejs-dev .

.PHONY: test
test: build
	@docker run --rm -it optimized/docker-nodejs-dev bash -c "node -v; yarn -v; yarn install && echo Test passed; exit;"
