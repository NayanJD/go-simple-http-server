.DEFAULT_GOAL := help

# Variables
TERRAFORM_IMAGE = hashicorp/terraform:latest

# Help target
help:
	@echo "Available targets:"
	@echo "  tf-init   -  terraform init"
	@echo "  tf-apply  - terraform apply"
	@echo "  tf-destroy  - terraform destroy"
	@echo "  tf-plan  - terraform plan"
	@echo "  tf-fmt  - terraform plan"
	@echo "  tf-validate  - terraform validate"

# Droplet targets
# Pattern rule for droplet commands
tf-%: droplet-%
	@true

# Hidden implementation targets
tf-init:
	cd terraform && docker run --rm -v $(PWD)/terraform:/workspace -w /workspace $(TERRAFORM_IMAGE) init

tf-apply:
	cd terraform && docker run --rm -v $(PWD)/terraform:/workspace -w /workspace \
		-e TF_VAR_do_token \
		-e DIGITALOCEAN_API_TOKEN \
		-e TF_VAR_ssh_key_ids \
		$(TERRAFORM_IMAGE) apply -auto-approve

tf-destroy:
	cd terraform && docker run --rm -v $(PWD)/terraform:/workspace -w /workspace -e TF_VAR_do_token -e DIGITALOCEAN_API_TOKEN $(TERRAFORM_IMAGE) destroy -auto-approve

tf-plan:
	cd terraform && docker run --rm -v $(PWD)/terraform:/workspace -w /workspace \
		-e TF_VAR_do_token \
		-e DIGITALOCEAN_API_TOKEN \
		-e TF_VAR_ssh_key_ids \
		$(TERRAFORM_IMAGE) plan

tf-fmt:
	cd terraform && docker run --rm -v $(PWD)/terraform:/workspace -w /workspace $(TERRAFORM_IMAGE) fmt

tf-validate:
	cd terraform && docker run --rm -v $(PWD)/terraform:/workspace -w /workspace $(TERRAFORM_IMAGE) validate



# Public target that combines init and apply
# droplet-create: _droplet-init _droplet-apply

# droplet-cleanup: _droplet-destroy

.PHONY: help _droplet-init _droplet-apply droplet-create droplet-plan droplet-destroy droplet-fmt droplet-validate

