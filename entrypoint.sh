#!/bin/bash

java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=prod -jar dataries-eureka-1.0.0.jar
