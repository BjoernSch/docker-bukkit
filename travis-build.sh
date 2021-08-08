#! /bin/bash

set -xe

# Build
if [[ -z "$DOCKERFILE" ]]; then
	docker build --build-arg BUKKIT_VERSION=$TAG JAVA_VERSION=$JAVA_VERSION -t bjoernsch/spigot:$TAG .
else
	docker build -f $DOCKERFILE --build-arg BUKKIT_VERSION=$TAG JAVA_VERSION=$JAVA_VERSION -t bjoernsch/spigot:$TAG .
fi

# Test
docker run -it -p 25565:25565 -v /data:/data -e EULA=true -e TRAVIS=true bjoernsch/spigot:$TAG

if [[ "$TRAVIS_BRANCH" = "master" ]]; then
	docker push bjoernsch/spigot:$TAG
else
	exit 0
fi
