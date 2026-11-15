#!/usr/bin/env bash
# Phase 4: Read-only verification (for the user-selected context)
set -eu
helm list -A
kubectl get deployment aws-load-balancer-controller -n kube-system
kubectl get pods -n nginx-ingress
kubectl get svc -n nginx-ingress
kubectl get ingressclass
kubectl get ingress -A
kubectl describe svc nginx-ingress-controller -n nginx-ingress
aws elbv2 describe-load-balancers --region ap-southeast-2 --query 'LoadBalancers[].[LoadBalancerName,Type,Scheme,State.Code,DNSName]' --output table
