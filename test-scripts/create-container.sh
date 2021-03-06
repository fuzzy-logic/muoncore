#!/bin/sh

#curl -vvv -X POST http://172.17.42.1:4321/containers/create?name=sentiment -d '{ "Hostname":"ubersentiment", "Env":["GIT_REPO_URL=https://github.com/fuzzy-logic/sentanal.git"], "Image":"sp_platform/uber-any" }' -H 'Content-Type: application/json'


curl -vvv -X POST http://172.17.0.3:8080/cell -d '{ "id": "simplenode", "image": "sp_platform/uber-any", "env": { "GIT_REPO_URL": "https://github.com/fuzzy-logic/simplenode.git" } }' -H 'Content-Type: application/json'


sleep 10

IPADDR=`docker inspect 5cf8be02bd5b | grep -i IPAddress | awk -F\" '{print $4}'`

curl -vvv -X GET http://$IPADDR:8080/
