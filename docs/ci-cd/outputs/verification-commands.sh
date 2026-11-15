#!/usr/bin/env bash
# Read-only Phase 5 verification - run on Ubuntu admin EC2 with kubectl configured.
set -euo pipefail
cd "${HOME}/vprofile-eks-gitops"
echo "=== Recent commits ==="
git log -5 --oneline
echo "=== Helm application image tag ==="
grep -A 5 '^app:' helm/vprofile-chart/values.yaml
echo "=== EKS deployed application image ==="
kubectl get deployment vproapp -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
echo "=== Argo CD application sync/health ==="
kubectl get application vprofile -n argocd -o jsonpath='{.status.sync.status}{" | "}{.status.health.status}{"\n"}'
