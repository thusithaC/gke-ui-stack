# Setting up instructions

Crating a role and a service account for deploying to GKE:

```shell

gcloud iam service-accounts create gke-deployer \
    --description="Service account for deploying to GKE" \
    --display-name="GKE Deployer"

PROJECT_ID=$(gcloud config get-value project)

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/container.developer"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"
    
gcloud iam service-accounts keys create ~/gke-deployer-key.json \
    --iam-account="gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com"
```


Impersonating the service account:
```shell
gcloud iam service-accounts add-iam-policy-binding gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com \
    --member="user:${USER_EMAIL}" \
    --role="roles/iam.serviceAccountTokenCreator"
    
gcloud auth activate-service-account --key-file="/home/${USER}/gke-deployer-key.json"
gcloud config set account gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com
gcloud auth print-access-token 
```

After the service account is activated, setting up the cluster to use the service account:

```shell
gcloud container clusters get-credentials  autopilot-cluster-1 \
--zone us-central1	 \
--project "${PROJECT_ID}"

kubectl create namespace tnc
kubectl get pods -n tnc

```


For managing remote state of the bucket,
```shell
# gcloud auth login

# Grant the service account the Storage Object Admin role for read, write, and delete access
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/storage.objectAdmin"

# Grant the service account the Storage Admin role to list buckets and manage bucket metadata
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/storage.admin"
    
gcloud storage buckets create gs://project-state-tnc --project=${PROJECT_ID} --location=us-central1

```

For IAP, 
```shell

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iap.admin"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iap.httpsResourceAccessor"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/firebase.managementServiceAgent"    

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:gke-deployer@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/secretmanager.admin"
        
```


Terraform commands:
```shell


```

```shell
sudo certbot certonly -d app.tncdsprod.online \
--preferred-challenges dns-01 --manual -m test@app.tncdsprod.online
```


# Kubernetes

```shell
kubectl delete -f infrastructure/manifests/utils.yaml
envsubst < infrastructure/manifests/utils.yaml | kubectl apply -f -

kubectl apply -f infrastructure/manifests/backend.yaml
kubectl apply -f infrastructure/manifests/ui.yaml
#kubectl apply -f infrastructure/manifests/lb.yaml
envsubst < infrastructure/manifests/lb.yaml | kubectl apply -f -

kubectl -n tnc describe gateway backend-gateway
kubectl -n tnc get gateway backend-gateway
kubectl -n tnc describe service backend-service
kubectl -n tnc describe GCPBackendPolicy


kubectl delete -f infrastructure/manifests/ui.yaml
kubectl delete -f infrastructure/manifests/backend.yaml
kubectl delete -f infrastructure/manifests/lb.yaml
envsubst < infrastructure/manifests/utils.yaml | kubectl delete -f -

kubectl get secret iap-oauth-secret -n tnc -o jsonpath="{.data.key}" | base64 --decode
# gcloud secrets versions access latest --secret="iap-client-secret" --format="get(payload.data)"