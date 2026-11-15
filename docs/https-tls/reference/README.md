# TLS Secret manifest - SECURITY WARNING

The reference manifest in this folder is illustrative and deliberately **not deployable**. Never put an actual `tls.key` private key or a base64-encoded TLS Secret manifest in a public Git repository. Kubernetes base64 `data` is not encryption.

The actual TLS Secret in the user's `default` namespace was created declaratively from a private YAML stored outside Git. For a reproducible lab procedure, generate it locally with `kubectl create secret tls ... --dry-run=client -o yaml` and apply it with the correct cluster kubeconfig. Secure the saved YAML (`umask 077`, root-owned directory), and rotate it after manual renewal. Production choices include cert-manager and encrypted-secret/secret-store integrations.
