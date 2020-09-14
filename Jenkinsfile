pipeline {
	agent any
//	agent {
//		kubernetes {
//			yaml """
//apiVersion: v1
//kind: Pod
//metadata:
//  name: builder-deployer
//  namespace: build
//spec:
//  containers:
//  - name: kaniko
//    image: gcr.io/kaniko-project/executor:debug
//    command:
//    - cat
//    volumeMounts:
//    - name: docker-config
//      mountPath: /kaniko/.docker/
//    tty: true
//  - name: bitnami
//    image: bitnami/kubectl
//    command:
//    - cat
//    volumeMounts:
//    - name: kube-config
//      mountPath: /.kube/
//    tty: true
//  volumes:
//  - name: docker-config
//    configMap:
//      name: docker-config
//  - name: kube-config
//    secret:
//      secretName: kube-config
//"""
//		}
//	}
	stages {
		stage( 'Build DotNet Core Source from Github and Deploy to the Cluster ' ) {
			steps {
//				container( name: 'kaniko', shell: '/busybox/sh' ) {
//					sh """
//					echo $pwd
//					/kaniko/executor --dockerfile=Dockerfile --context=git://github.com/burhanuguz/dotnet-core-hello-world --destination=burhanuguz/dotnet-core-hello-world:$BUILD_NUMBER
//					"""
//				}				
				node('master') {
					script {
						sh '''
						kubectl set image -n dotnet-core deployments/dotnet-core-helloworld dotnet=burhanuguz/dotnet-core-hello-world:$BUILD_NUMBER
						'''
					}
				}
			}
		}
	}
}
