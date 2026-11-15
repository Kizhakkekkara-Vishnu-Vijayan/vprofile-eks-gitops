#!/bin/bash
# Ubuntu 24.04 EC2 user data - EKS administration workstation
# Installs tools only; DOES NOT create an EKS cluster.
set -Eeuo pipefail
export DEBIAN_FRONTEND=noninteractive
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export AWS_DEFAULT_REGION=ap-southeast-2
export AWS_REGION=ap-southeast-2

exec > >(tee -a /var/log/eks-admin-bootstrap.log) 2>&1
trap 'rc=$?; echo "[ERROR] Bootstrap failed at line $LINENO (exit code $rc)" >&2' ERR

echo "[INFO] Starting EKS admin tools bootstrap: $(date -Is)"

case "$(uname -m)" in
  x86_64) ARCH=amd64; AWS_ARCH=x86_64 ;;
  aarch64) ARCH=arm64; AWS_ARCH=aarch64 ;;
  *) echo "Unsupported CPU architecture: $(uname -m)" >&2; exit 1 ;;
esac

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates curl wget unzip zip tar gzip git jq \
  gnupg openssl bash-completion dnsutils nano vim less

WORKDIR="$(mktemp -d /tmp/eks-admin-install.XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT
cd "$WORKDIR"

# AWS CLI v2, official installer
curl -fsSL --retry 5 \
  "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o awscliv2.zip
unzip -q awscliv2.zip
./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli

# eksctl, official GitHub release; verify archive checksum
EKSCTL_ARCHIVE="eksctl_Linux_${ARCH}.tar.gz"
curl -fsSL --retry 5 \
  "https://github.com/eksctl-io/eksctl/releases/latest/download/${EKSCTL_ARCHIVE}" \
  -o "$EKSCTL_ARCHIVE"
curl -fsSL --retry 5 \
  "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" \
  -o eksctl_checksums.txt
awk -v name="$EKSCTL_ARCHIVE" '$2 == name || $2 == "*" name {print; exit}' \
  eksctl_checksums.txt > eksctl_archive.sha256
test -s eksctl_archive.sha256
sha256sum --check eksctl_archive.sha256
tar -xzf "$EKSCTL_ARCHIVE" eksctl
install -m 0755 eksctl /usr/local/bin/eksctl

# kubectl: latest patch of the planned Kubernetes v1.36 minor
KUBECTL_VERSION="$(curl -fsSL --retry 5 \
  https://dl.k8s.io/release/stable-1.36.txt | tr -d '\r\n')"
case "$KUBECTL_VERSION" in
  v1.36.*) echo "[INFO] Installing kubectl ${KUBECTL_VERSION}" ;;
  *) echo "Unexpected kubectl version: $KUBECTL_VERSION" >&2; exit 1 ;;
esac
KUBECTL_URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}"
curl -fsSL --retry 5 "${KUBECTL_URL}/kubectl" -o kubectl
curl -fsSL --retry 5 "${KUBECTL_URL}/kubectl.sha256" -o kubectl.sha256
echo "$(cat kubectl.sha256)     kubectl" | sha256sum --check
install -m 0755 kubectl /usr/local/bin/kubectl

# Helm 3, official installer
curl -fsSL --retry 5 \
  https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  -o get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

# Set region for ubuntu user; no static access keys written
runuser -u ubuntu -- /usr/local/bin/aws configure set region ap-southeast-2
runuser -u ubuntu -- /usr/local/bin/aws configure set output json

kubectl completion bash > /etc/bash_completion.d/kubectl
helm completion bash > /etc/bash_completion.d/helm

aws --version
eksctl version
kubectl version --client
helm version --short
git --version
jq --version

echo "Completed: $(date -Is)" > /var/lib/eks-admin-bootstrap.done
echo "[SUCCESS] EKS admin tools installed; no AWS cluster/resources created."
