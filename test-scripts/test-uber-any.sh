#!/bin/sh


curl -vvv -X POST http://172.17.0.3:8080/cell -d '{ "id": "simplenode", "image": "sp_platform/uber-any", "env": { "GIT_REPO_URL": "https://github.com/fuzzy-logic/simplenode.git" } }' -H 'Content-Type: application/json'
sleep 10
curl -X GET http://localhost:8888/ -H 'Host: cell-simplenode'



curl -vvv -X POST http://172.17.0.3:8080/cell -d '{ "id": "sentanal", "image": "sp_platform/uber-any", "env": { "GIT_REPO_URL": "https://github.com/fuzzy-logic/sentanal.git" } }' -H 'Content-Type: application/json'
sleep 10
curl -X GET http://localhost:8888/ -H 'Host: cell-simplenode'
