# makefiles for docker https://earthly.dev/blog/docker-and-makefiles/

DOCKER_USERNAME ?= erikpack
APPLICATION_NAME ?= bitcoind
 
build:
    docker build -t ${DOCKER_USERNAME}/${APPLICATION_NAME} .

run:
	docker run -d  ${DOCKER_USERNAME}/${APPLICATION_NAME}

# get container local ip https://stackoverflow.com/questions/17157721/how-to-get-a-docker-containers-ip-address-from-the-host
# validate bitcoind is running https://www.reddit.com/r/Bitcoin/comments/ip62ik/is_there_a_curl_or_nc_command_to_test_node/g4j3dvc/
test: build run
	sleep 10
	export CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps | grep ${APPLICATION_NAME} | cut -d ' ' -f 1))
	nc -v -n -z ${CONTAINER_IP} 8333

logparser-sh:
	cat ./test/logs.txt | cut -d ' ' -f 2 | sort | uniq -c | sort -bgr

logparser-py:
	python3 logparser.py

nomad-agent-config:
	$(MAKE) -C ./tf/nomad nomad-agent-config
	nomad agent -config=agent.nomad.hcl

nomad-deploy:
	$(MAKE) -C ./tf/nomad nomad-deploy
	terraform init
	terraform plan
	terraform apply
