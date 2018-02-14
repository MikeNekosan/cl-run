#!/bin/sh

for i in `docker images -q`
do docker rmi -f ${i}
done
docker network prune --force

for i in `docker ps -q -a`
do docker rm -f ${i}
done


