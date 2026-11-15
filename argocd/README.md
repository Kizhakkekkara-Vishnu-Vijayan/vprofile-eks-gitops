# Argo CD application - VProfile EKS

This folder contains the **working** `application.yaml` in the real Git repository. The documentation archive intentionally does not overwrite that live file.

- [Phase 6 GitOps walkthrough with screenshots](../docs/argo-cd/README.md)
- [Observed reference manifest](../docs/argo-cd/outputs/observed-application-reference.yaml)
- [Observed console output](../docs/argo-cd/outputs/verified-phase6-output.txt)
- [Read-only validation commands](../docs/argo-cd/outputs/verification-commands.sh)
- [Auto Sync screenshot](screenshots/argocd-auto-sync-state.png)
- [Argo CD resource tree screenshot](screenshots/argocd-resource-tree.png)

## Apply the live declaration

```bash
kubectl config current-context
kubectl apply -f argocd/application.yaml
kubectl get application vprofile -n argocd
```

Read `argocd/application.yaml` before applying it. The current observed sync policy is `enabled: true`, `prune: false`, `selfHeal: true`. When self-healing is enabled, change Helm values in Git instead of patching workloads directly. See the Phase 6 guide for a full explanation and recorded results.
