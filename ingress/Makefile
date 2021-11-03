account = $(shell aws sts get-caller-identity --query "Account" --output text)
# Get the current Main Cluster name
cluster = $(shell basename $$(kubectl config current-context))
include ../stages/*$(stage)
host = $(shell aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[DNSName]' --output text)


# list the available targets
targets:
	@make -qp | awk -F':' '/^[a-z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

# Creates ingress controller
controller:
	@kubectl apply -f ingresscontroller.yaml

controllerdel:
	@kubectl delete -f ingresscontroller.yaml

# Creates ingeressrule in a namespace
ingressrule:
	@echo "namespace is $(namespace)"
	@cat ingressrule.yaml | sed "s|NAMESPACE|$(namespace)|g;s|HOST|$(host)|g" | kubectl apply -f -

ingressruledel:
	@cat ingressrule.yaml | sed "s|NAMESPACE|$(namespace)|g;s|HOST|$(host)|g" | kubectl delete -f -


