pipeline {
	agent {
		kubernetes {
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
		stage( 'Build DotNet Core Source from Github and Deploy to the Cluster ' ) {
			steps {
//				container( name: 'kaniko', shell: '/busybox/sh' ) {
//					sh """
//					/kaniko/executor --dockerfile=Dockerfile --context=git://github.com/burhanuguz/dotnet-core-hello-world --destination=burhanuguz/dotnet-core-hello-world
//					"""
//				}
				container( 'bitnami' ) {
					sh """
					ls -la
					kubectl apply -f deploy.yaml
					"""
				}
			}
		}
	}
}
