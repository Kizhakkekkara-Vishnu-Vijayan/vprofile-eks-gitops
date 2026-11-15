#!/usr/bin/env bash
# Read-only Phase 6 verification, run with kubectl access to vprofile-eks.
set -euo pipefail
kubectl config current-context
kubectl get pods -n argocd
kubectl get application vprofile -n argocd
kubectl get application vprofile -n argocd -o jsonpath='{.spec.syncPolicy.automated}{"\n"}'
kubectl describe application vprofile -n argocd
kubectl get deployments -n default
kubectl get pods -n default -o wide
kubectl get services -n default
kubectl get ingress -n default
kubectl get deployment vproapp -n default -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
kubectl top nodes
