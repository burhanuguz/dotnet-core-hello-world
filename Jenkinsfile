pipeline {
	agent {
		kubernetes {
			label 'kaniko-builder'
			yaml """
apiVersion: v1
kind: Pod
metadata:
  name: kaniko
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
  restartPolicy: Never
  volumes:
  - name: docker-config
    configMap:
      name: docker-config
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
				curl https://2886795355-31000-elsy05.environments.katacoda.com//job/build-deployer/build?token=build-deployer
			}
		}
	}
}
