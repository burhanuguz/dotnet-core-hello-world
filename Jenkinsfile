pipeline {
	agent {
		kubernetes {
			label 'builder-deployer'
			yaml """
apiVersion: v1
kind: Pod
metadata:
  name: builder-deployer
  namespace: build
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - cat
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker/
    tty: true
  - name: bitnami
    image: bitnami/kubectl
    command:
    - cat
    volumeMounts:
    - name: kube-config
      mountPath: /.kube/
    tty: true
  restartPolicy: Never
  volumes:
  - name: docker-config
    configMap:
      name: docker-config
  - name: kube-config
    secret:
      secretName: kube-config
"""
		}
	}
	stages {
		stage( 'Build DotNet Core Source from Github' ) {
			steps {
				container( name: 'kaniko', shell: '/busybox/sh' ) {
					sh """
					/kaniko/executor --dockerfile=Dockerfile --context=git://github.com/burhanuguz/dotnet-core-hello-world --destination=burhanuguz/dotnet-core-hello-world
					"""
				}
				writeFile file: "deploy.yaml", text: """
					apiVersion: apps/v1
					kind: Deployment
					metadata:
					name: dotnet-core-helloworld
					namespace: dotnet-core
					spec:
					selector:
						matchLabels:
						run: dotnet
					replicas: 1
					template:
						metadata:
						labels:
							run: dotnet
						spec:
						containers:
						- name: dotnet
							image: burhanuguz/dotnet-core-hello-world:latest
							ports:
							- containerPort: 11130
							resources:
							limits:
								cpu: 500m
							requests:
								cpu: 1m
					---
					apiVersion: v1
					kind: Service
					metadata:
					name: dotnet-core-helloworld
					namespace: dotnet-core
					labels:
						run: dotnet
					spec:
					ports:
					- port: 80
						targetPort: 11130
						nodePort: 30000
					selector:
						run: dotnet
					type: NodePort
				"""
				container( 'kubectl-deployer' ) {
					sh """
					kubectl apply -f deploy.yaml
					"""
				}
			}
		}
	}
}
