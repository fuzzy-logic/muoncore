package simplepaas.controlplane.commands

import groovy.util.logging.Slf4j
import groovyx.net.http.HTTPBuilder
import org.springframework.beans.factory.annotation.Autowired
import simplepaas.controlplane.JSONApi

import static groovyx.net.http.ContentType.JSON
import static groovyx.net.http.Method.POST

@Slf4j
class SendContainerInformation {
  @Autowired
  JSONApi dockerApi

  def call() {

    def dockerRet = dockerApi.get("/containers/json")

    dockerRet.each {
      it.id = it.Id
      it.inspection = dockerApi.get("/containers/${it.Id}/json")
      it.provides = generateProvides(it.inspection)
      //it.processes = dockerApi.get("/containers/${it.Id}/top")
      //it.files = dockerApi.get("/containers/${it.Id}/changes")
      it.links = [
          [rel:"self", href:"http://172.17.0.2:8080/container/${it.Id}".toString()],
          [rel:"stdout", href:"http://172.17.0.2:8080/container/${it.Id}/stdout".toString()],
          [rel:"stderr", href:"http://172.17.0.2:8080/container/${it.Id}/stderr".toString()]
      ]

      def http = new HTTPBuilder("http://172.17.0.4:8080/")
      def jsonResp

      try {
          http.request( POST, JSON ) { req ->
            body = [it]

            response.success = { resp, json ->
              jsonResp=json
            }
          }
      } catch (Exception e) {
        log.error("exception while posting docker container info to phenoype monitor " + e.message);
      }
    }
  }

  def generateProvides(containerInspection) {
    def provides = containerInspection.Config?.Env?.find {
      it.startsWith("PROVIDES")
    }

    if (!provides) {
      return []
    }

    def provisions = provides.substring(9)?.split(",")

    return provisions.collect {
      def (name, port) = it.split(":")
      [name: name, port: port]
    }
  }
}
