# Susu’s Haven GitOps practice kit

Prepared for Damilola Balogun, Intel Mac + Docker Desktop.

Start with **SETUP.md**. Do not run every script together. Use Argo CD and Flux separately, in the named local clusters. The scripts refuse to deploy to an unrelated current context.

## Included
- `website/index.html`: Version 1 of a working static website.
- `website/index-v2.html`: Version 2 for the release experiment.
- `Dockerfile`: packages either page with Nginx.
- `k8s/`: Deployment (three replicas), Service and Kustomize build.
- `gitops/`: Argo Application and Flux source/reconciliation templates.
- `scripts/`: explicit build/setup actions.
- `EXPERIMENTS.md`: workload replacement, configuration drift and app update.
- `OBSERVATIONS.md`: fill in actual outcomes for your practical slide.

This is a local learning kit, not a production configuration. Images are deliberately loaded into kind and use imagePullPolicy Never. Both v1 and v2 must be loaded before an update. There are no real accounts, secrets, checkout or payments.

The scripts and configuration have been statically checked. Cluster installation and reconciliations have not been executed on your Mac. Docker image downloads and current installer manifests require internet access. Record tool versions. The moving base-image/installer references are convenient for this lab; pin reviewed versions for a reproducible production workflow.
