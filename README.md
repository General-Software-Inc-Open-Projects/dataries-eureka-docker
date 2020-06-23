# Description

This image was created with the intention of achieving an easier deployment of Eureka Server component on Docker, to see the image, in Docker Hub, follow this [link](https://hub.docker.com/repository/docker/gsiopen/eureka). We are not associated with Netflix OSS in anyway.

# Quick reference

- Maintained by: [General Software Inc Open Projects](https://github.com/General-Software-Inc-Open-Projects/dataries-eureka-docker)
- Where to file issues: [GitHub Issues](https://github.com/General-Software-Inc-Open-Projects/dataries-eureka-docker/issues)

# What is Eureka?

The Eureka Server is a Netflix OSS product, and Spring Cloud offers a declarative way to use it to register and invoke services by Java annotation. This is a REST (Representational State Transfer) based service that is primarily used in the AWS cloud for locating services for the purpose of load balancing and failover of middle-tier servers.

# How to use this image

## Start a single node 

~~~bash
docker run -itd --name eureka -p 8761:8761 --restart on-failure gsiopen/eureka:1.0.0
~~~

## Connect to Eureka from the command line client

> This image is runned using a non root user `dataries` who owns the `/opt/eureka` folder.

~~~bash
docker exec -it eureka bash
~~~

## Check logs

By default, Eureka redirects stdout/stderr outputs to the console, so you can run the next command to find logs:

~~~bash
docker logs eureka
~~~

# Deploy a cluster

Eureka can be made even more resilient and available by running multiple instances and asking them to register with each other. In fact, this is the default behavior, so all you need to do to make it work is add a valid serviceUrl to a peer, as shown in the following example:

```application.yml (three Peer Aware Eureka Servers) ```

~~~bash
eureka:
  client:
    serviceUrl:
      defaultZone: http://peer1/eureka/,http://peer2/eureka/,http://peer3/eureka/

---
spring:
  profiles: peer1
eureka:
  instance:
    hostname: peer1

---
spring:
  profiles: peer2
eureka:
  instance:
    hostname: peer2

---
spring:
  profiles: peer3
eureka:
  instance:
    hostname: peer3
~~~

In the preceding example, we have a YAML file that can be used to run the same server on three hosts (peer1, peer2, peer3) by running it in different Spring profiles.

You can add multiple peers to a system, and, as long as they are all connected to each other by at least one edge, they synchronize the registrations amongst themselves. If the peers are physically separated (inside a data center or between multiple data centers), then the system can, in principle, survive “split-brain” type failures. You can add multiple peers to a system, and as long as they are all directly connected to each other, they will synchronize the registrations amongst themselves.

## Run the Eureka Servers from the command line client

Within the Dockerfile folder, run these commands in three different terminals:

```
mvn spring-boot:run -Dspring-boot.run.profiles=peer1
```
```
mvn spring-boot:run -Dspring-boot.run.profiles=peer2
```
```
mvn spring-boot:run -Dspring-boot.run.profiles=peer3
```

# Configuration

## Environment variables

The environment configuration is controlled via the following environment variable groups or PREFIX:

    EUREKA_INSTANCE_PREFER_IP_ADDRESS: affects application-prod.yml
    EUREKA_INSTANCE_HOSTNAME: affects application-prod.yml
    SERVER_PORT: affects application-prod.yml
    
Set environment variables with the appropriated group in the form PREFIX_PROPERTY.

Due to restriction imposed by docker and docker-compose on environment variable names the following substitution are applied to PROPERTY names:

    _ => .
    __ => _
    ___ => -

Following are some illustratory examples:

     SERVER_PORT=8761: sets the server.port property in application-prod.yml
     EUREKA_INSTANCE_PREFER_IP_ADDRESS=true: sets the eureka.instance.preferIpAddress property in application-prod.yml