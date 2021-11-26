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
	# kubectl delete clustermanagementaddon cluster-proxy
	kubectl delete clusterroles open-cluster-management:hub
	kubectl delete clusterroles open-cluster-management:hub:escalation
	kubectl delete clusterrolebinding open-cluster-management:hub
	kubectl delete clusterrolebinding open-cluster-management:hub:escalation
	# kubectl delete managedclusteraddons cluster-proxy
	# kubectl delete managedproxyconfiguration cluster-proxy
	# kubectl delete role -n open-cluster-management-cluster-proxy open-cluster-management:cluster-proxy:addon-manager
	# kubectl delete rolebindings -n open-cluster-management-cluster-proxy open-cluster-management:cluster-proxy:addon-manager
	# kubectl delete serviceaccounts -n open-cluster-management-cluster-proxy cluster-proxy

install-hub-registration:

uninstall-hub-registration:

install-agent-registration:

install-agent-crd:

install-agent-registration:


install-hub: install-hub-crd install-hub-cluster-proxy

uninstall-hub: uninstall-hub-cluster-proxy

