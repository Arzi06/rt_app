account = $(shell aws sts get-caller-identity --query "Account" --output text)
include ../stages/*$(stage)
image = $(account).dkr.ecr.us-east-1.amazonaws.com/simple_app:$(version)


# list the available targets
targets:
	@make -qp | awk -F':' '/^[a-z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort


login:
	@aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(account).dkr.ecr.us-east-1.amazonaws.com

build: login
	@docker build -t $(image) .

push: build
	@docker push $(image)

deploy: 
	@echo "namespace variable is set to $(namespace)"
	@cat namespace.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl apply -f -
	@cat frontsvc.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl apply -f -
	@cat frontend.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|ACCOUNT|$(account)|g" | kubectl apply -f -

delete:
	@cat frontend.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|ACCOUNT|$(account)|g" | kubectl delete -f -
	@cat frontsvc.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl delete -f -
	@cat namespace.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl delete -f -

image:
	@echo $(image)

# - ***Provide value for for Makefile to have the values 
# in stage folder. Ex. "make push dev"***