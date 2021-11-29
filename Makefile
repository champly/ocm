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

install-agent-registration:

install-agent-crd:

install-agent-registration:


install-hub: install-hub-crd install-hub-cluster-proxy install-hub-registration

uninstall-hub: uninstall-hub-cluster-proxy uninstall-hub-registration uninstall-hub-crd

