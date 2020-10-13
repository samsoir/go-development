DOCKER_BUILD_OPTS    :=--no-cache
DOCKER_BUILD_REPO    :=samsoir/alpine-shunit2
DOCKER_BUILD_LATEST  :=latest
DOCKER_BUILD_VERSION :=1.0

.PHONY: test build-base push 

test:
	@echo "Tests will run here"

build-base: 
	@echo "Building Docker container"
	docker build $(DOCKER_BUILD_OPTS) -f Dockerfile -t ${DOCKER_BUILD_REPO}:$(DOCKER_BUILD_LATEST) -t $(DOCKER_BUILD_REPO):$(DOCKER_BUILD_VERSION) .

push:
	@echo "Pushing latest container to Dockerhub $(DOCKER_BUILD_REPO)"
	docker push $(DOCKER_BUILD_REPO):$(DOCKER_BUILD_LATEST)
