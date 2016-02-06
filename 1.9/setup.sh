#!/bin/bash

docker-compose up -d

docker exec -t 19_web_1 mage-setup
