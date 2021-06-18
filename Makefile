IMAGE_NAME=simaofsilva/maven-openjdk11-alpine
ALPINE_VERSION=3.14.0
MAVEN_VERSION=3.8.1

build:
	DOCKER_CLI_EXPERIMENTAL=enabled \
	docker buildx build \
		--build-arg "ALPINE_VERSION=${ALPINE_VERSION}" \
		--build-arg "MAVEN_VERSION=${MAVEN_VERSION}" \
		--push \
		--platform=linux/amd64,linux/arm64/v8 \
		--tag ${IMAGE_NAME}:${ALPINE_VERSION}-${MAVEN_VERSION} \
		--tag ${IMAGE_NAME}:latest \
		--file Dockerfile \
		.

