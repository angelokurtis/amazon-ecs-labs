package br.com.kurtis.labs.ecs.api

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class EcsApiApplication

fun main(args: Array<String>) {
    runApplication<EcsApiApplication>(*args)
}
