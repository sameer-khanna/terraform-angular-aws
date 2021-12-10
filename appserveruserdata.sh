#!/bin/bash -xe

sudo bash

cd /var
mkdir api
cd api
mkdir springboot
cd springboot

aws s3 cp s3://app-deployables-us/terraformsample-0.0.1-SNAPSHOT.jar /var/api/springboot

java -jar terraformsample-0.0.1-SNAPSHOT.jar