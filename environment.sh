#!/bin/bash

# a bash script to source in order to set up your command line to interact with
# a specific beamline. This needs to be customized per beamline / domain

# check we are sourced
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "ERROR: Please source this script"
    exit 1
fi

THIS_DIR=$(dirname ${0})

echo "Loading IOC environment for blxxi ..."

#### SECTION 1. Environment variables ##########################################

# a mapping between genenric IOC repo roots and the related container registry
# use spaces to separate multiple mappings
export EC_REGISTRY_MAPPING='github.com=ghcr.io'
# the namespace to use for kubernetes deployments - leave blank for local docker
export EC_K8S_NAMESPACE=
# the git repo for this beamline (or accelerator domain)
export EC_DOMAIN_REPO=git@github.com:epics-containers/blxxi-template.git
# declare your centralised log server Web UI
# export EC_LOG_URL='https://graylog2.diamond.ac.uk/search?rangetype=relative&fields=message%2Csource&width=1489&highlightMessage=&relative=172800&q=pod_name%3A{ioc_name}*'
# enforce a specific container cli - defaults to whatever is available
# export EC_CONTAINER_CLI=podman
# enable debug output in all 'ec' commands
# export EC_DEBUG=1


#### SECTION 2. Install ec #####################################################

# check if epics-containers-cli (ec command) is installed and install if not
if ! ec --version &> /dev/null; then
    # must be in a venv and this is the reliable check
    if python3 -c 'import sys; sys.exit(0 if sys.base_prefix==sys.prefix else 1)'; then
        echo "ERROR: Please activate a virtualenv and re-run"
        return
    elif ! ec --version &> /dev/null; then
        pip install -r ${THIS_DIR}/requirements.txt
    fi
    ec --install-completion ${SHELL} &> /dev/null
fi

# enable shell completion for ec commands
source <(ec --show-completion ${SHELL})


#### SECTION 3. Configure Kubernetes Cluster ###################################
# example of how we set up a cluster at DLS is below
# SET UP Connection to KUBERNETES CLUSTER and set default namespace.
# if module --version &> /dev/null; then
#     if module avail k8s-ixx > /dev/null; then
#         module unload k8s-ixx > /dev/null
#         module load k8s-ixx > /dev/null
#         # set the default namespace for kubectl and helm (for convenience only)
#         kubectl config set-context --current --namespace=ixx-iocs
#         # get running iocs: makes sure the user has provided credentials
#         ec ps
#     fi
# fi


