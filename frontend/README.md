# RT_APP - directory consists of:

`\frontend` - contains Dockerfile, source code, K8S manifest files (deployment, service, namespace)

`\Makefile`

#### Used Documentation:
- https://kubernetes.io/docs/concepts/
- https://docs.docker.com/language/python/build-images/

### Instruction for Makefile: run the following commands in turn to dockerize application and build K8S objects

1. `make targrets` - displays all Makefile targets

2. `make targrets` - `make push` - the commands depend each other. It will wait push -> build -> login 

3. `make deploy` - create : K8S objects: service, deployment and namespace 

### For deleting:

- `make delete` - **delete everything that was created**

- ***Provide value for for Makefile to have the values in stage folder. Ex. "make ingressrule dev"***
