# Experiments and expected observations
These are predictions to verify, not results already obtained. Use the named local cluster only.

## 1. Kubernetes replaces a missing managed Pod
Do this after manual deployment and before installing Argo CD:
```bash
kubectl get pods -n lab
kubectl delete pod ACTUAL_POD_NAME -n lab
kubectl get pods -n lab -w
```
Replace the name with one from the list. Expected: a new Pod appears. Control-C stops watching. Kubernetes handled replacement; no GitOps tool was installed.

Now change the live instruction:
```bash
kubectl scale deployment/susu-haven -n lab --replicas=5
kubectl get deployment susu-haven -n lab
kubectl apply -k k8s
```
Expected: Kubernetes follows five, then the final apply restores the file’s three. It does not reread Git by itself.

## 2. Argo detects drift in manual mode
After connecting/syncing the Argo app, with Git declaring three:
```bash
kubectl scale deployment/susu-haven -n lab --replicas=5
argocd app get susu-haven --refresh
```
Expected: OutOfSync and live five. Detection and automatic correction differ.

## 3. Argo automatic correction
```bash
argocd app set susu-haven --sync-policy automated --self-heal
kubectl get deployment susu-haven -n lab -w
```
Expected: declared replicas return to three after reconciliation. Control-C stops the watch. Inspect the actual sync message if it does not correct.

## 4. Argo release of Version 2
Both images were loaded by cluster setup. In VS Code change only `image: susu-haven:v1` to `image: susu-haven:v2` in k8s/deployment.yaml.
```bash
git add k8s/deployment.yaml
git commit -m "Deploy Version 2"
git push
argocd app get susu-haven --refresh
kubectl rollout status deployment/susu-haven -n lab --timeout=180s
```
Wait for automated sync. Alternatively request `argocd app sync susu-haven` if appropriate. Refresh/restart your port-forward and view the website: Version 2 has a different headline. Restore v1 in Git and push when done.

## 5. Flux configuration drift
In the Flux cluster, Git should again declare three and v1:
```bash
kubectl scale deployment/susu-haven -n lab --replicas=5
flux reconcile kustomization susu-haven --with-source
kubectl get deployment susu-haven -n lab
```
Expected: declared count returns to three. This tests Kustomize reconciliation, not Helm drift correction.

## 6. Desired-state changes through Git with Flux
Change replicas to four in k8s/deployment.yaml, commit and push:
```bash
git add k8s/deployment.yaml
git commit -m "Request four replicas"
git push
flux reconcile kustomization susu-haven --with-source
kubectl get deployment susu-haven -n lab
```
Expected: four is now correct because Git declares four. Restore three, commit/push/reconcile. Then repeat the Version 2 change with Flux and inspect the site. Restore v1 after recording observations.

## What this does not test
This kit does not test Helm releases, image scanning/automation, production security, public traffic, database recovery or multi-cluster performance. Our images are built locally and preloaded; the registry step in the conceptual slide is intentionally skipped for this first local practical.
