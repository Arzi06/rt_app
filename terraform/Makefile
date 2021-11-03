service = eks_dev


# list the available targets
targets:
	@make -qp | awk -F':' '/^[a-z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

create_S3:
	cd backend && terraform init && terraform apply -auto-approve

rm_S3:
	cd backend && terraform destroy -auto-approve

init: 
	cd project_eks && terraform init && terraform plan

# Do not need to create file "config_map_aws_auth.yaml" below, it creates or deletes by Terraform
apply:
	cd project_eks && terraform apply -auto-approve 
	aws eks update-kubeconfig --name $(service)
	kubectl apply -f config_map_aws_auth.yaml

destroy:
	cd project_eks && terraform destroy -auto-approve