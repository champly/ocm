HUB-KUBECONFIG?=$(HOME)/.kube/config

install-hub-crd:
	kubectl apply -f deploy/hub/crd/addon.clustermanagementaddons.yaml
	kubectl apply -f deploy/hub/crd/addon.managedclusteraddons.yaml
	kubectl apply -f deploy/hub/crd/clusters.managedclusters.yaml
	kubectl apply -f deploy/hub/crd/clusters.managedclustersetbindings.yaml --validate=false
	kubectl apply -f deploy/hub/crd/clusters.managedclustersets.yaml --validate=false
	kubectl apply -f deploy/hub/crd/proxy.managedproxyconfigurations.yaml
	kubectl apply -f deploy/hub/crd/work.manifestworks.yaml

uninstall-hub-crd:
	kubectl delete -f deploy/hub/crd/addon.clustermanagementaddons.yaml
	kubectl delete -f deploy/hub/crd/addon.managedclusteraddons.yaml
	kubectl delete -f deploy/hub/crd/clusters.managedclusters.yaml
	kubectl delete -f deploy/hub/crd/clusters.managedclustersetbindings.yaml
	kubectl delete -f deploy/hub/crd/clusters.managedclustersets.yaml
	kubectl delete -f deploy/hub/crd/proxy.managedproxyconfigurations.yaml
	kubectl delete -f deploy/hub/crd/work.manifestworks.yaml

install-hub-cluster-proxy:
	helm upgrade --install -n open-cluster-management-cluster-proxy --create-namespace cluster-proxy deploy/hub/cluster-proxy

uninstall-hub-cluster-proxy:
	kubectl delete managedcluster --all
	kubectl delete managedclusteraddon --all
	kubectl delete manifestworks --all
	helm uninstall -n open-cluster-management-cluster-proxy cluster-proxy
	kubectl delete clustermanagementaddon cluster-proxy --ignore-not-found=true
	kubectl delete clusterroles open-cluster-management:hub --ignore-not-found=true
	kubectl delete clusterroles open-cluster-management:hub:escalation --ignore-not-found=true
	kubectl delete clusterrolebinding open-cluster-management:hub --ignore-not-found=true
	kubectl delete clusterrolebinding open-cluster-management:hub:escalation --ignore-not-found=true
	kubectl delete managedclusteraddons cluster-proxy --ignore-not-found=true
	kubectl delete managedproxyconfiguration cluster-proxy --ignore-not-found=true
	kubectl delete -n open-cluster-management-cluster-proxy role open-cluster-management:cluster-proxy:addon-manager --ignore-not-found=true
	kubectl delete -n open-cluster-management-cluster-proxy rolebindings open-cluster-management:cluster-proxy:addon-manager --ignore-not-found=true
	kubectl delete -n open-cluster-management-cluster-proxy serviceaccounts cluster-proxy --ignore-not-found=true
	kubectl delete -n open-cluster-management-cluster-proxy service proxy-agent-entrypoint --ignore-not-found=true
	kubectl delete namespace open-cluster-management-cluster-proxy

install-hub-registration:
	kubectl apply -f deploy/hub/registration/namespace.yaml
	kubectl apply -f deploy/hub/registration/deployment.yaml
	kubectl apply -f deploy/hub/registration/hub_controller_clusterrole.yaml
	kubectl apply -f deploy/hub/registration/hub_controller_clusterrole_binding.yaml
	kubectl apply -f deploy/hub/registration/managedcluster_escalation_clusterrole.yaml
	kubectl apply -f deploy/hub/registration/managedcluster_escalation_clusterrolebinding.yaml
	kubectl apply -f deploy/hub/registration/service_account.yaml

uninstall-hub-registration:
	kubectl delete -f deploy/hub/registration/deployment.yaml --ignore-not-found=true
	kubectl delete -f deploy/hub/registration/hub_controller_clusterrole.yaml --ignore-not-found=true
	kubectl delete -f deploy/hub/registration/hub_controller_clusterrole_binding.yaml --ignore-not-found=true
	kubectl delete -f deploy/hub/registration/managedcluster_escalation_clusterrole.yaml --ignore-not-found=true
	kubectl delete -f deploy/hub/registration/managedcluster_escalation_clusterrolebinding.yaml --ignore-not-found=true
	kubectl delete -f deploy/hub/registration/service_account.yaml --ignore-not-found=true
	kubectl delete -f deploy/hub/registration/namespace.yaml --ignore-not-found=true

install-agent-crd:
	kubectl apply -f deploy/agent/crd/clusters.clusterclaims.yaml
	kubectl apply -f deploy/agent/crd/appliedmanifestworks.yaml

uninstall-agent-crd:
	kubectl delete -f deploy/agent/crd/clusters.clusterclaims.yaml --ignore-not-found=true
	kubectl delete -f deploy/agent/crd/appliedmanifestworks.yaml --ignore-not-found=true

install-agent-bootstrap-secret:
	kubectl create secret generic bootstrap-secret --from-file=kubeconfig=$(HUB-KUBECONFIG) -n open-cluster-management

uninstall-agent-bootstrap-secret:
	kubectl delete secret bootstrap-secret -n open-cluster-management
	kubectl delete appliedmanifestworks --all

install-agent-registration:
	kubectl apply -f deploy/agent/registration/namespace.yaml
	kubectl apply -f deploy/agent/registration/clusterrole.yaml
	kubectl apply -f deploy/agent/registration/clusterrole_binding.yaml
	kubectl apply -f deploy/agent/registration/deployment.yaml
	kubectl apply -f deploy/agent/registration/role.yaml
	kubectl apply -f deploy/agent/registration/role_binding.yaml
	kubectl apply -f deploy/agent/registration/service_account.yaml

uninstall-agent-registration:
	kubectl delete -f deploy/agent/registration/clusterrole.yaml
	kubectl delete -f deploy/agent/registration/clusterrole_binding.yaml
	kubectl delete -f deploy/agent/registration/deployment.yaml
	kubectl delete -f deploy/agent/registration/role.yaml
	kubectl delete -f deploy/agent/registration/role_binding.yaml
	kubectl delete -f deploy/agent/registration/service_account.yaml
	kubectl delete -f deploy/agent/registration/namespace.yaml

install-agent-work:
	kubectl create namespace open-cluster-management-agent
	kubectl create secret generic hub-kubeconfig-secret --from-file=kubeconfig=$(HUB-KUBECONFIG) -n open-cluster-management-agent
	kubectl apply -f deploy/agent/work/clusterrole.yaml
	kubectl apply -f deploy/agent/work/clusterrole_binding.yaml
	kubectl apply -f deploy/agent/work/clusterrole_binding_addition.yaml
	kubectl apply -f deploy/agent/work/component_namespace.yaml
	kubectl apply -f deploy/agent/work/deployment.yaml
	kubectl apply -f deploy/agent/work/service_account.yaml

uninstall-agent-work:
	kubectl delete secret hub-kubeconfig-secret -n open-cluster-management-agent --ignore-not-found=true
	kubectl delete -f deploy/agent/work/clusterrole.yaml --ignore-not-found=true
	kubectl delete -f deploy/agent/work/clusterrole_binding.yaml --ignore-not-found=true
	kubectl delete -f deploy/agent/work/clusterrole_binding_addition.yaml --ignore-not-found=true
	kubectl delete -f deploy/agent/work/component_namespace.yaml --ignore-not-found=true
	kubectl delete -f deploy/agent/work/deployment.yaml --ignore-not-found=true
	kubectl delete -f deploy/agent/work/service_account.yaml --ignore-not-found=true
	kubectl delete namespace open-cluster-management-agent --ignore-not-found=true

install-hub: install-hub-crd install-hub-cluster-proxy install-hub-registration

uninstall-hub: uninstall-hub-cluster-proxy uninstall-hub-registration uninstall-hub-crd
	@kubectl delete -f deploy/hub/managedclusteraddon.yaml --ignore-not-found=true

apply-managedcluster:
	@kubectl apply -f deploy/hub/managedclusteraddon.yaml

apply-hub-kubeconfig:
	kubectl create secret generic cluster-proxy-hub-kubeconfig --from-file=kubeconfig=$(HUB-KUBECONFIG) -n open-cluster-management-cluster-proxy

install-agent: install-agent-crd install-agent-registration install-agent-bootstrap-secret install-agent-work

uninstall-agent: uninstall-agent-bootstrap-secret uninstall-agent-work uninstall-agent-registration uninstall-agent-crd

