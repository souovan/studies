.PHONY: help

help: ## Show help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# SHELL := /usr/bin/zsh
SHELL := /bin/bash

.DEFAULT_GOAL := help

RED = \033[1;31m
GREEN = \033[1;32m
RESET = \033[0m

VMS_WITH_ANSIBLE := ansible node1 node2 node3 node4 node5
VMS := node1 node2 node3 node4 node5
INVENTORY := inventory
PLAYBOOK := playbooks/master.yml
VAGRANT := VAGRANT_DEFAULT_PROVIDER=vmware_desktop vagrant

# VARIABLE="some-value"

# hello: ## Show ${VARIABLE} value
# 	@echo ${VARIABLE}

# shell: hello ## Calls hello task and Print $SHELL value
# 	@echo ${SHELL}

start-vms: ## Start all lab VMs with Vagrant (vmware_desktop provider)
	@echo "Starting Vagrant environment..."
	@$(VAGRANT) up

start-ansible: ## Start only the Ansible control node
	@echo "Starting Ansible control node..."
	@$(VAGRANT) up ansible

provision: ## Re-run provisioning on the Ansible control node
	@echo "Re-provisioning Ansible control node..."
	@$(VAGRANT) provision ansible

shutdown-vms: ## Gracefully stop all lab VMs
	@echo "Stopping Vagrant environment..."
	@$(VAGRANT) halt

destroy-vms: ## Destroy all lab VMs
	@echo "$(RED)Destroying Vagrant environment...$(RESET)"
	@$(VAGRANT) destroy -f

status: ## Show Vagrant status for the lab
	@$(VAGRANT) status

ssh-%: ## SSH into a VM using Vagrant (usage: make ssh-node1)
	@$(VAGRANT) ssh $*

ansible-ping: ## Run ansible ping against all hosts
	ansible -i $(INVENTORY) all -m ping

ansible-play: ## Run main Ansible playbook
	ansible-playbook -i $(INVENTORY) $(PLAYBOOK)
