#!/bin/bash

# Wait for the control-plane to be ready
until kubectl get nodes &>/dev/null; do sleep 5; done
sleep 15

# Drain and reset node01 to simulate a worker that has never joined the cluster
# This forces the learner to generate a join token and run kubeadm join manually

# Drain node01 gracefully (ignore daemonsets, delete local data)
kubectl drain node01 --ignore-daemonsets --delete-emptydir-data --force &>/dev/null || true

# Delete node01 from the cluster registry
kubectl delete node node01 &>/dev/null || true

# Reset kubeadm state on node01 so it can be re-joined
ssh -o StrictHostKeyChecking=no node01 "kubeadm reset -f &>/dev/null && \
  rm -rf /etc/cni/net.d /var/lib/cni /var/lib/kubelet /etc/kubernetes &>/dev/null && \
  systemctl stop kubelet &>/dev/null" &>/dev/null || true

exit 0
