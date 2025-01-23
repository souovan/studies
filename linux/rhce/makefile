.PHONY: help

help: ## Show help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# SHELL := /usr/bin/zsh
SHELL := /bin/bash

.DEFAULT_GOAL := help

RED = \033[1;31m
GREEN = \033[1;32m
RESET = \033[0m

VMS_WITH_ANSIBLE := "ansible" "node1.9" "node2.9" "node3.9" "node4.9" "node5.9"
VMS := "node1.9" "node2.9" "node3.9" "node4.9" "node5.9"

SNAPSHOT := "updated-configured"
SNAPSHOT_ANSIBLE := "pre-collection-installs"

# VARIABLE="some-value"

# hello: ## Show ${VARIABLE} value
# 	@echo ${VARIABLE}

# shell: hello ## Calls hello task and Print $SHELL value
# 	@echo ${SHELL}

start-vms: ## Start hosts Lab VMs
	@for item in $(VMS); do \
		echo "starting VM: $$item"; \
		sudo virsh start $$item; \
	done

shutdown-vms: ## Shutdown hosts Lab VMs
	@for item in $(VMS); do \
		echo "starting VM: $$item"; \
		sudo virsh shutdown $$item; \
	done

reset-ansible: ## Clean all Ansible VM configuration
	@echo "limpando toda configuração da VM Ansible"
	ssh ansible -- "rm -rf /home/van/ansible; \
	rm /home/van/.vimrc; \
	sudo dnf remove rhel-system-roles -y; \
	sudo dnf remove ansible-core -y; \
	sudo -s pip3 uninstall ansible-navigator -y"

revert-snapshot-ansible: ## Revert ansible VM to snapshot "pre-collection-installs"
	@echo "revertendo snapshot ansible para snapshot: $(SNAPSHOT_ANSIBLE)"; \
	sudo virsh snapshot-revert ansible --snapshotname $(SNAPSHOT_ANSIBLE)

revert-snapshot-hosts: ## Revert hosts VMS to snapshot "updated-configured"
	@for item in $(VMS); do \
		echo "revertendo snapshot $$item para snapshot: $(SNAPSHOT)"; \
		sudo virsh snapshot-revert $$item --snapshotname $(SNAPSHOT); \
	done

revert-snapshot-all: ## Revert all VMS to snapshot "updated-configured"
	@for item in $(VMS_WITH_ANSIBLE); do \
		echo "revertendo snapshot $$item para snapshot: $(SNAPSHOT)"; \
		sudo virsh snapshot-revert $$item --snapshotname $(SNAPSHOT); \
	done