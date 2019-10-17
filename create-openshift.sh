#!/bin/bash
NAME=credentials ./create-file-secret.sh credentials
NAME=gcp-mysql-backup ./create-env-secret.sh .env
oc create -f openshift.yaml