# Ingress Controlller - directory consists of:

`\ingress` - contains manifest files to create ingress
controller with Network Loadbalncer and ingress rule 
to map host

`\Makefile`

#### Used Documentation:
https://kubernetes.github.io/ingress-nginx/deploy/

### Instruction for Makefile: run the following commands in turn to create the Ingress Controller

1. `make controller` - to run Ingress Controller deployment

2. `make ingressrule` - to create Ingress Rule to map flow to the host

3. `make targets` - to seee All targets

### For deleting:

- `make ingressruledel` - **delete Ingress Rule**

- `make controller` - **to delete Ingress Controller deployment**

- ***Provide value for for Makefile to have the values in stage folder. Ex. "make ingressrule dev"***