# Easy docker set up for Atlassian tools

Based on cptactionhank's work.

## Add users on the host system

```
addgroup --gid 70   postgres
adduser  --uid 70   --system --no-create-home --ingroup postgres postgres
addgroup --gid 2000 jira
adduser  --uid 2000 --system --no-create-home --ingroup jira jira
addgroup --gid 2001 confluence
adduser  --uid 2001 --system --no-create-home --ingroup confluence confluence
```

## Create the volumes

```
mkdir -p /srv/atlassian
chmod 777 /srv/atlassian

mkdir /srv/atlassian/jira
chown jira:jira /srv/atlassian/jira
chmod 700 /srv/atlassian/jira

mkdir /srv/atlassian/confluence
chown confluence:confluence /srv/atlassian/confluence
chmod 700 /srv/atlassian/confluence
```

## Start up the containers

```
docker build base -t atlassian_base
docker-compose build
docker-compose up -d
```

## Create databases

```
docker exec -it atlassian-database /bin/bash

createuser -e -U postgres -P jira
createdb -e -U postgres -E UNICODE -l C -T template0 -O jira jira

createuser -e -U postgres -P confluence
createdb -e -U postgres -E UNICODE -l C -T template0 -O confluence confluence

```


