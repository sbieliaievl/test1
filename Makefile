# Provide environment variables to tasks
.EXPORT_ALL_VARIABLES:

provider=$(or ${PROVIDER},'WRONG')
environment=$(or ${ENVIRONMENT},'WRONG')
cluster=$(or ${CLUSTER},'WRONG')
vault_id=$(if ${ANSIBLE_VAULT_PASSWORD_FILE},$(environment)@${ANSIBLE_VAULT_PASSWORD_FILE},$(environment)@~/.ansible/${provider}_$(environment))

apply=false
debug=false

# Enable Ansible Check mode when apply is set to false
ifeq ($(apply), false)
	override extra_args += --check
endif

# Enable Helm debug mode from Ansible shared role when debug is set to true
ifeq ($(debug), true)
	override extra_args += -e helm_debug=true -e hide_sensitive_logs=false -vvv
endif

# ------
# Common tasks
# ------

requirements:
	pip install -r requirements.txt
	pre-commit install
	asdf install
