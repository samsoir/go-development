DOCKER_BUILD_OPTS    :=--no-cache
DOCKER_BUILD_REPO    :=samsoir/debian-shunit2
DOCKER_BUILD_LATEST  :=latest
DOCKER_BUILD_VERSION :=1.0
DOCKER_TEST_NAME     :=go-development-test

.PHONY: test build-base push 

test:
	docker build $(DOCKER_BUILD_OPTS) -f .docker/Dockerfile.test -t $(DOCKER_TEST_NAME) .
	docker run --name $(DOCKER_TEST_NAME) --rm -d -t $(DOCKER_TEST_NAME) /bin/bash
	docker exec $(DOCKER_TEST_NAME) ./install.sh && echo "PATH=\$PATH:/usr/local/bin/go" >> ~/.bashrc
	docker exec $(DOCKER_TEST_NAME) examples/test_go_version.sh
	docker stop $(DOCKER_TEST_NAME)

build-base: 
	@echo "Building Docker container"
	docker build $(DOCKER_BUILD_OPTS) -f .docker/Dockerfile.base -t ${DOCKER_BUILD_REPO}:$(DOCKER_BUILD_LATEST) -t $(DOCKER_BUILD_REPO):$(DOCKER_BUILD_VERSION) .

push:
	@echo "Pushing current container to Dockerhub $(DOCKER_BUILD_REPO)"
	docker push $(DOCKER_BUILD_REPO):$(DOCKER_BUILD_VERSION)

push-latest:
	@echo "Pushing latest container to Dockerhub $(DOCKER_BUILD_REPO)"
	docker push $(DOCKER_BUILD_REPO):$(DOCKER_BUILD_LATEST)
