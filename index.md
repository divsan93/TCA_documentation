---
layout: default
title: Home
nav_order: 1
description: "TCA Documentation"
permalink: /
---

# Tackle Container Advisor (TCA)

## Purpose

TCA takes client applications as a natural language description and recommends whether client applications can be containerized. For example, a client can provide the application description as the following.

```
1. App1: rhel, db2, java, tomcat
```


TCA takes the following steps to recommend the containerization.

1. **Assessment**: It assesses the application to standardize the inputs to relevant named entities present in our knowledge base. For details on the knowledge base please check the *db* folder. For example, the inputs in *App1* get mapped as the following named entities.

```
1. App1: rhel: Linux|RedHat Linux, db2: DB2, java: Java, tomcat: Apache Tomcat
```

2. **Containerization**: First, it recommends whether *App1* can be containerized, partially containerized, or kept as it is. Then if App1 is recommended as containerized or partially containerized, TCA generates container images based on DockerHub or Openshift. For example, if a user decides to generate DockerHub related images, then TCA generates the following images.

```
1. tomcat|https://hub.docker.com/_/tomcats
2. db2|https://hub.docker.com/r/ibmcom/db2
```

For OpenShift, TCA generates the following images.

	1. tomcat|https://access.redhat.com/containers/#/registry.access.redhat.com/jboss-webserver-3/webserver31-tomcat8-openshift
	2. db2|https://access.redhat.com/containers/#/cp.stg.icr.io/cp/ftm/base/ftm-db2-base

## TCA Pipeline

![TCA Pipeline](/images/tca_pipeline.png)

The pipeline ingests raw inputs from clients data and standardizes the data to generate named entities and versions. For standardizing or normalizing raw inputs we use a tf-idf similarity based approach. To find container images we represent images in terms of named entities as well. The normalized representation helps to match legacy applications with container images to suggest the best possible recommendations.
