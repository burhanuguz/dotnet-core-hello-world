pipeline {
	agent {
		kubernetes {
			yamlFile 'kaniko.yaml'
		}
	}
	stages {
		stage( 'Build DotNet Core Source from Github and Deploy to the Cluster ' ) {
			steps {
				container( name: 'kaniko', shell: '/busybox/sh' ) {
					sh """
					echo $pwd
					/kaniko/executor --dockerfile=src/Dockerfile --context=git://github.com/burhanuguz/dotnet-core-hello-world --destination=burhanuguz/dotnet-core-hello-world:$BUILD_NUMBER
					"""
				}				
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
