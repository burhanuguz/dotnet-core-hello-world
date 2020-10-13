#!/bin/bash

launch.sh
# Clone Jenkins contents that is specifically made for this lab and pull jenkins image on node01
ssh root@node01 'git clone https://github.com/burhanuguz/jenkins-custom /tmp/jenkins-custom ; \
                 chmod -R ugo+rwx /tmp/jenkins-custom/jenkins_home ; \
                 docker pull jenkins/jenkins'

# Deploy metrics server with insecure flag to make it work on this ephemeral environment
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml && \
sed -i '/.*--secure-port=4443.*/a \ \ \ \ \ \ \ \ \ \ - --kubelet-insecure-tls' components.yaml && \
kubectl create -f components.yaml

# Create necessary namespaces
kubectl create ns jenkins
kubectl create ns build
kubectl create ns dotnet-core

# Create Jenkins Instance in Kubernetes
kubectl apply -f https://raw.githubusercontent.com/burhanuguz/dotnet-core-hello-world/master/deployments/jenkins.yaml

# Create Deployment which will be updated throughout builds
kubectl apply -f https://raw.githubusercontent.com/burhanuguz/dotnet-core-hello-world/master/deployments/deployment.yaml

kubectl autoscale deployment -n dotnet-core dotnet-core-helloworld --cpu-percent=50 --min=1 --max=3
