TERRAFORM_DIR = terraform
ANSIBLE_DIR = ansible

init:
	cd $(TERRAFORM_DIR) && terraform init \
		-backend-config="access_key=$${YC_S3_ACCESS_KEY}" \
		-backend-config="secret_key=$${YC_S3_SECRET_KEY}"

validate:
	cd $(TERRAFORM_DIR) && terraform validate

plan:
	cd $(TERRAFORM_DIR) && terraform plan

apply:
	cd $(TERRAFORM_DIR) && terraform apply

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

output:
	cd $(TERRAFORM_DIR) && terraform output

fmt:
	cd $(TERRAFORM_DIR) && terraform fmt

state-list:
	cd $(TERRAFORM_DIR) && terraform state list

install-roles:
	cd $(ANSIBLE_DIR) && ansible-galaxy install -r requirements.yml

install-collections:
	cd $(ANSIBLE_DIR) && ansible-galaxy collection install -r requirements.yml

setup:
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml --tags setup --ask-vault-pass

deploy:
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml --tags deploy --ask-vault-pass

deploy-all:
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml --ask-vault-pass

healthcheck:
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml --tags healthcheck --ask-vault-pass

monitoring:
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml --tags monitoring --ask-vault-pass

encrypt:
	ansible-vault encrypt $(ANSIBLE_DIR)/group_vars/all/vault.yml

decrypt:
	ansible-vault decrypt $(ANSIBLE_DIR)/group_vars/all/vault.yml

view-vault:
	ansible-vault view $(ANSIBLE_DIR)/group_vars/all/vault.yml

.PHONY: init validate plan apply destroy output fmt state-list \
	install-roles install-collections setup deploy deploy-all healthcheck monitoring \
	encrypt decrypt view-vault
