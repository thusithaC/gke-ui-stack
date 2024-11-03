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