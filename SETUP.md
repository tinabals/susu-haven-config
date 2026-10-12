# Setup: do these steps in order

## 1. Extract and open the project
Unzip the download. Open the `susu-haven` folder in VS Code. Open Terminal and `cd` into that folder. All commands below assume this is your current folder. You can type `cd ` and drag the extracted folder into Terminal.

Open Docker Desktop and wait until it is running. Check:
```bash
sw_vers -productVersion
uname -m
docker version
git --version
brew --version
```
Intel normally reports x86_64. Docker should show a client and server. If Homebrew is missing, follow https://brew.sh/ first; your macOS version must be supported. If Git is missing, follow https://git-scm.com/downloads/mac. Share errors before proceeding.

## 2. Install tools if needed
```bash
brew install kind kubectl argocd fluxcd/tap/flux
kind version
kubectl version --client
argocd version --client
flux --version
```
You need internet access and sufficient Docker Desktop CPU/memory. Run one cluster at a time on a resource-constrained Mac.

## 3. Build and preview the website
```bash
bash scripts/01-build-images.sh
docker run -d --name susu-preview -p 8080:80 susu-haven:v1
```
Open http://localhost:8080. Expected: Version 1 and “Rest in His presence.”
```bash
docker stop susu-preview
docker rm susu-preview
```
These last commands release port 8080; the images remain.

## 4. Create your practice GitHub repository
Create a new PUBLIC repository named `susu-haven-config`, with **no** initial README/license/gitignore, so it is empty. Use a practice repository with no credentials or private files. You may publish the complete kit; the controllers only reconcile `k8s/`.

From this project folder:
```bash
git init -b main
git add .
git commit -m "Add Susu Haven practice kit"
git remote add origin https://github.com/YOUR_USERNAME/susu-haven-config.git
git push -u origin main
```
Replace YOUR_USERNAME. If Git requests identity, configure your intended name/email before committing. If authentication is requested, use your Git provider’s supported sign-in flow. Never paste tokens into this kit or chat. No one has created a remote repository on your behalf.

Open the repository and confirm `main` contains `k8s/deployment.yaml`, `k8s/service.yaml` and `k8s/kustomization.yaml`. It must be publicly retrievable for these unauthenticated templates.

## 5. Create the Argo practice cluster
```bash
bash scripts/02-create-cluster.sh argo
bash scripts/03-deploy-manually.sh
```
Check that the context is `kind-susu-argo-lab` and Pods become Ready. Preview in a separate tab:
```bash
kubectl port-forward -n lab service/susu-haven 8080:80
```
Keep it running, open localhost:8080, then Control-C to stop forwarding. Workload controllers continue running.

Do Experiment 1 BEFORE installing GitOps. Then:
```bash
bash scripts/04-install-argo.sh
kubectl get pods -n argocd
```
Wait for the main components to be Ready. In a separate tab:
```bash
kubectl port-forward -n argocd svc/argocd-server 8081:443
```
Leave that running. In the main tab:
```bash
argocd admin initial-password -n argocd
argocd login localhost:8081 --username admin --insecure
bash scripts/06-connect-source.sh argo https://github.com/YOUR_USERNAME/susu-haven-config.git
argocd app sync susu-haven
argocd app get susu-haven
```
Enter the password at the prompt, keep it private. The UI is https://localhost:8081. `--insecure` skips certificate verification for this local self-signed demo only. The Application starts in manual-sync mode. Do the Argo experiments in EXPERIMENTS.md.

## 6. Set up Flux separately
Record the Argo results. Restore the Git file to `replicas: 3` and `image: susu-haven:v1`, commit/push, and stop all port-forwards. To free resources, delete ONLY the disposable Argo cluster when finished:
```bash
kind delete cluster --name susu-argo-lab
bash scripts/02-create-cluster.sh flux
bash scripts/05-install-flux.sh
bash scripts/06-connect-source.sh flux https://github.com/YOUR_USERNAME/susu-haven-config.git
flux get sources git
flux get kustomizations
kubectl get pods -n lab
```
The Flux controller creates the app from Git. This kit uses install plus explicit custom resources rather than a full bootstrap of Flux’s own configuration. Wait for Ready, then follow the Flux experiments.

## 7. Finish
Stop forwarding sessions with Control-C. When done, remove ONLY the disposable Flux cluster:
```bash
kind delete cluster --name susu-flux-lab
```
Keep the website, images, Git history and observations for learning. No cloud account, paid hosting or public domain is required.

## Troubleshooting
- Docker unavailable: open Docker Desktop.
- ErrImageNeverPull: load the exact image into the correct kind cluster.
- Pending: inspect node capacity and scheduling events.
- Port busy: stop an old forwarding/container session or use another host port.
- Source not Ready: check URL, main branch, public access and connectivity.
- Argo OutOfSync: inspect sync policy and operation results.
- Flux source Ready but apply fails: inspect path/YAML/permissions.
```bash
kubectl config current-context
kubectl get pods -A
kubectl describe pod ACTUAL_POD_NAME -n lab
kubectl logs ACTUAL_POD_NAME -n lab
kubectl get events -n lab --sort-by=.metadata.creationTimestamp
```
ACTUAL_POD_NAME is a placeholder to replace. Post the actual error, not credentials.

Official references: https://kind.sigs.k8s.io/docs/user/quick-start/ ; https://argo-cd.readthedocs.io/en/stable/getting_started/ ; https://fluxcd.io/flux/get-started/
