package br.com.kurtis.labs.ecs.api

import org.springframework.stereotype.Service
import java.nio.file.Files
import java.nio.file.Paths

@Service
class ContainerService {

    private val dockerCgroupPath: String by lazy {
        "/proc/self/cgroup"
    }

    fun getContainerInfo(): ContainerInfo = ContainerInfo(getContainerId())

    private fun getContainerId(): String {
        val cgroup = String(Files.readAllBytes(Paths.get(dockerCgroupPath)))
        val firstLine = cgroup.split(Regex(System.lineSeparator()), 2).first()
        return firstLine.split("/").last()
    }
}
