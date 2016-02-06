#!/bin/bash

docker-compose up -d

docker exec -t 16_web_1 mage-setup
