package br.com.kurtis.labs.ecs.api

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/container/v1")
class DockerContainerResource(val service: ContainerService) {

    @GetMapping("/info")
    fun containerInfo(): ContainerInfo = service.getContainerInfo()
}

