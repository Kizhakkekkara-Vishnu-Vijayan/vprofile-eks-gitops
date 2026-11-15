# VProfile on Amazon EKS - implementation evidence

This repo documents the **actual AWS lab** through reproducible commands, verified outputs, real AWS Console screenshots, explanations and operational checks. Add these files to the root of `vprofile-eks-gitops` alongside the existing `eks/`, `helm/`, `argocd/`, `.github/` and `Docker-files/` directories.

| Phase | Guide | Evidence status |
| --- | --- | --- |
| 01 - Administration EC2 | [EC2 provisioning, IAM, User Data and CLI tools](docs/ec2-administration/README.md) | Confirmed with screenshots and tool outputs |
| 02 - EKS cluster | [Cluster creation, managed workers, stacks and checks](docs/eks-cluster/README.md) | Confirmed with EKS, CloudFormation and terminal screenshots |
| 03 - Persistent storage / Pod Identity | [EBS CSI, gp3, PVC/PV and AWS EBS](docs/persistent-storage/README.md) | **Confirmed** by three screenshots: Active add-ons, Bound PVC/PV, In-use gp3 volume |
| 04 - NGINX and AWS NLB | [AWS load balancing and NGINX evidence](docs/load-balancing/README.md) | Confirmed NLB target groups, controller and IAM policy |
| 05 - CI / Docker | [Containerization, GitHub Actions jobs, SHA-based images and Helm automation](docs/ci-cd/README.md) | **Confirmed:** successful CI run, Docker Hub image tags, Helm bot commit and running image |
| 06 - Argo CD and Kubernetes resources | [Argo CD Auto Sync, Deployments, Pods and website change](docs/argo-cd/README.md) | **Confirmed:** automated sync, 4/4 workloads, and before/after web change |
| 07 - Let's Encrypt TLS + HTTPS | [Manual DNS-01, Kubernetes TLS Secret, Helm Ingress and live HTTPS validation](docs/https-tls/README.md) | **Confirmed:** LE trusted certificate, TLS 1.3, HTTPS 200, HTTP 301, Argo CD Healthy, 4/4 Pods |

## Documentation approach

Each chapter describes **purpose → prerequisite → command → explanation → real output → AWS console evidence → troubleshooting**. An image represents a point-in-time state, not necessarily current status or a permanent SLA. Screenshots are redacted for publication.

## Architecture summary

`Administrator EC2 (default VPC)` → `eksctl / AWS EKS (dedicated EKS VPC)` → `c7i-flex.large managed worker` → `Kubernetes services and NGINX ingress` → `public AWS NLB` → `VProfile web application`. CI/CD: `GitHub Actions → Docker Hub → Helm values commit → Argo CD → EKS`.

**Cost/safety:** This is a single-worker lab. Administrator IAM and public SSH shown in original screenshots are not recommended for production. Limit ingress; do not publish AWS account IDs, SSH private keys, tokens or application secrets.


## Phase 4 - Load Balancing and Ingress (verified)

- [AWS Load Balancer Controller & NGINX Ingress implementation](docs/load-balancing/README.md)
- [Observed terminal output](docs/load-balancing/outputs/verified-terminal-output.txt)
- [IAM policy evidence snapshot](docs/load-balancing/reference/README.md)

Evidence: AWS internet-facing NLB, IP target groups healthy on TCP/80 and TCP/443, F5 NGINX Ingress Helm release, and dedicated controller IAM role. Screenshots are in the Phase 4 README.


## Phase 5 - CI / Docker (verified)

- [Full implementation guide, screenshots and observed Git output](docs/ci-cd/README.md)
- [Read-only verification commands](docs/ci-cd/outputs/verification-commands.sh)
- [Suggested documentation-only workflow path filters](docs/ci-cd/outputs/recommended-paths-ignore.yaml)

Proof: all four jobs succeeded for commit `93773bd`; Helm bot commit `be12a98`. Later source commit `fa861db` generated Helm bot commit `c87b615` and the exact image tag was observed in the EKS Deployment. Do not replace the working CI, Helm, or Dockerfiles with documentation copies.

## Phase 6 - Argo CD automated GitOps (verified)

- [Illustrated GitOps walkthrough and actual evidence](docs/argo-cd/README.md)
- [Argo CD folder landing README](argocd/README.md)
- [Verbatim command excerpts](docs/argo-cd/outputs/verified-phase6-output.txt)

Evidence: Argo CD deployed GitOps revision `c2e57d19...` automatically, serving image `sha-c638788...` with a before/after UI change in `welcome.jsp`.


## Phase 7 - Let's Encrypt HTTPS and Certificate Management (verified)

- [Illustrated security and HTTPS implementation](docs/https-tls/README.md)
- [Verbatim verification excerpts (cookie redacted)](docs/https-tls/outputs/verified-phase7-terminal.txt)
- [Read-only validation script](docs/https-tls/outputs/verify-https-readonly.sh)

Evidence: issued Let's Encrypt wildcard certificate expiring 12 Feb 2027; GoDaddy DNS-01 challenge; Kubernetes `vprofile-tls` Secret; Helm Ingress TLS and F5 NGINX redirect; Argo CD `Synced / Healthy`; TLS 1.3 and trusted HTTPS 200; HTTP-to-HTTPS 301; four application Pods Running. The manual DNS certificate does **not** renew unattended.
