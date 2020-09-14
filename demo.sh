#!/bin/bash

# Clone Jenkins contents that is specifically made for this lab and pull jenkins image on node01
ssh root@node01 'git clone https://520112e60d2349186a9fb497fcbbc3792d1d5988@github.com/burhanuguz/jenkins-private /tmp/jenkins-private ; \
                 chmod -R ugo+rwx /tmp/jenkins-private/jenkins_home ; \
                 docker pull jenkins/jenkins'

# Deploy metrics server with insecure flag to make it work on this ephemeral environment
wget https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml && \
sed -i '/.*--secure-port=4443.*/a \ \ \ \ \ \ \ \ \ \ - --kubelet-insecure-tls' components.yaml && \
kubectl create -f components.yaml

# Create necessary namespaces
kubectl create ns jenkins
kubectl create ns build
kubectl create ns dotnet-core

# Create resource for Jenkins to connect Kubernetes Cluster
kubectl create secret generic -n build kube-config --from-file=/root/.kube/config

# Create Jenkins Instance in Kubernetes
kubectl apply -f https://raw.githubusercontent.com/burhanuguz/dotnet-core-hello-world/master/jenkins.yaml

# Create Deployment which will be updated throughout builds
kubectl apply -f https://raw.githubusercontent.com/burhanuguz/dotnet-core-hello-world/master/deployment.yaml

kubectl wait --for=condition=ready pod -n jenkins $(kubectl get pods --no-headers -o custom-columns=":metadata.name" -n jenkins)
