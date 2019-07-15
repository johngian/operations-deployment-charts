#!/bin/sh

# this script sets up a bootstrap tiller on kube-system for hemlfile to use.
# we need to give it cluster-admin privileges since it will need to create namespaces.

# KUBECONFIG=admin-staging.config./initialize_cluster.sh kube-system neon.eqiad.wmnet 6443

set -x
set -e

SERVICEACCOUNT=${SERVICEACCOUNT:-"tiller"}
KUBECONFIG=${KUBECONFIG:-"/etc/kubernetes/kubeconfig"}
NAMESPACE=$1
KUBERNETES_SERVICE_HOST=$2
KUBERNETES_SERVICE_PORT=$3


# Annotate the namespace so that calico will enforce a default deny network policy
KUBECONFIG=$KUBECONFIG kubectl annotate namespace ${NAMESPACE} "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

# Create the service account under which tiller will run
KUBECONFIG=$KUBECONFIG kubectl create serviceaccount ${SERVICEACCOUNT} -n ${NAMESPACE}

# create the tiller role binding. We use a cluster role for DRY purposes
KUBECONFIG=$KUBECONFIG kubectl -n ${NAMESPACE} create clusterrolebinding ${SERVICEACCOUNT} --clusterrole=cluster-admin --serviceaccount="${NAMESPACE}:${SERVICEACCOUNT}"

# Initialize helm
KUBECONFIG=$KUBECONFIG helm init --service-account ${SERVICEACCOUNT} \
	--tiller-namespace=${NAMESPACE} \
	--tiller-image=docker-registry.discovery.wmnet/tiller:2.12.2-wmf1 \
	--override spec.template.spec.containers[0].env[2].name"="${KUBERNETES_SERVICE_HOST} \
	--override spec.template.spec.containers[0].env[2].value"="neon.eqiad.wmnet  \
	--override spec.template.spec.containers[0].env[3].name"="${KUBERNETES_SERVICE_PORT} \
	--override spec.template.spec.containers[0].env[3].value"="6443 \
	--skip-refresh