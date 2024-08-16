# makefiles for docker https://earthly.dev/blog/docker-and-makefiles/

DOCKER_USERNAME ?= erikpack
APPLICATION_NAME ?= bitcoind
 
build:
    docker build --tag ${DOCKER_USERNAME}/${APPLICATION_NAME} .

run:
	docker run -d  ${DOCKER_USERNAME}/${APPLICATION_NAME}

test: build run
# get container local ip https://stackoverflow.com/questions/17157721/how-to-get-a-docker-containers-ip-address-from-the-host
# validate bitcoind is running https://www.reddit.com/r/Bitcoin/comments/ip62ik/is_there_a_curl_or_nc_command_to_test_node/g4j3dvc/
	sleep 10
	export CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps | grep ${APPLICATION_NAME} | cut -d ' ' -f 1))
	nc -v -n -z ${CONTAINER_IP} 8333