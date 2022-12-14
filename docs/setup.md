---
layout: default
title: Setup and Running TCA
nav_order: 3
---
# Setting up your environment

Requires Python >= 3.6 environment. You cannot run this code without having a proper 
Python environment first. We recommend that you follow the instructions 
in the [Developer's Guide](docs/development.md) before proceeding further.

# Running TCA as a service

There are 4 options for deploying TCA as a service. 

1. Install the service requirements and start the service from command line.

Requires *gunicorn* standalone installation on your system.
```
bash setup.sh
gunicorn --workers=2 --threads=500 --timeout 300 service:app
OR
waitress-serve --listen=*:8000 service:app 
```

2. Running the service as a container. 

Using a bash script. 
```
bash run.sh
```
Using command line.
```
docker-compose  -f 'docker-compose-api.yml' up -d --build
```

3. Running the service in a virtual machine using vagrant.
```
vagrant up
vagrant ssh
cd /vagrant
bash run.sh
```

4. Deploy the container on Redhat Openshift Container Platform.

```
bash deploy.sh
```

# Run a performance test for TCA service
A performance test measures the response time of TCA service under
various load conditions. Before running 
performance test, update *config/test.ini* with the hostname
and port where TCA service has been deployed

```
python test/performance/run_payload.py <#users> <#applications/user>
```

# Running TCA with a new version of Knowledge Base

Please perform the following steps.

1. Replace the existing .sql file with the new <new_db>.sql file in the db folder

2. Change the *common.ini* file in the config folder as follows

    version = <new_db>

3. Modify the *setup.sh* and *clean.sh* scripts to reflect the version accordingly.
    
    version=<new_db>

4. Re-run *setup.sh* and then deploy the service.

