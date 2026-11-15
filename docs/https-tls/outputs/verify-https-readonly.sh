#!/usr/bin/env bash
# Read-only verification of VProfile HTTPS. Run with EKS kubeconfig on Ubuntu administration EC2.
set -eu
printf '\n===== CONTEXT =====\n'
kubectl config current-context
printf '\n===== TLS SECRET METADATA ONLY =====\n'
kubectl get secret vprofile-tls -n default
printf '\n===== LIVE TLS INGRESS =====\n'
kubectl get ingress vpro-ingress -n default -o jsonpath='{.spec.tls[0].secretName}{"\n"}'
kubectl describe ingress vpro-ingress -n default
printf '\n===== ARGO CD =====\n'
kubectl get application vprofile -n argocd
printf '\n===== APPLICATION PODS =====\n'
kubectl get pods -n default -o wide
printf '\n===== HTTPS CERTIFICATE AND RESPONSE =====\n'
curl -Iv --max-time 20 https://vprofile.vishnuhosting.xyz/ 2>&1 | grep -E 'SSL connection|subject:|issuer:|subjectAltName|verify ok|< HTTP/' || true
printf '\n===== HTTP REDIRECT =====\n'
curl -I --max-time 20 http://vprofile.vishnuhosting.xyz/
