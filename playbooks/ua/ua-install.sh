set -euo pipefail
/usr/local/bin/ezfabricctl pc -i /tmp/ua-prechecks.yaml -s /tmp/prechecksStatus.txt
/usr/local/bin/ezfabricctl o init -p ~/ezfab-release.tgz -i /tmp/ezkf-input.yaml -s /tmp/ezkf-orch-status.txt --save-kubeconfig /tmp/mgmt-kubeconfig
/usr/local/bin/ezfabricctl ph i -i /tmp/hostPoolConfig.yaml -c /tmp/mgmt-kubeconfig -s /tmp/hostPoolConfigStatus.txt
/usr/local/bin/ezfabricctl w i -i /tmp/clusterConfig.yaml -c /tmp/mgmt-kubeconfig -s /tmp/clusterConfigStatus.txt
/usr/local/bin/ezfabricctl w g k -n ua40 -i /tmp/clusterConfig.yaml -c /tmp/mgmt-kubeconfig -s /tmp/clusterConfigStatus.txt --save-kubeconfig /tmp/workload-kubeconfig
kubectl --kubeconfig=/tmp/workload-kubeconfig apply -f /tmp/ezkfWorkloadDeploy.yaml
