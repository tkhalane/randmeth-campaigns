# create role assignment between acr and aks
az aks update -n docatalog -g devops-catalog-aks --attach-acr devopscatalogaks

# destroy targeted resources only
terraform destroy --var k8s_version=<version> --target azurerm_kubernetes_cluster.primary


## AZURE ACR ##
az acr create --resource-group devops-catalog-aks --name devopscatalogaks --sku Basic
az acr login --name devopscatalogaks
docker tag tii/go-demo-9 devopscatalogaks.azurecr.io/go-demo-9:latest
docker push devopscatalogaks.azurecr.io/go-demo-9:latest

az acr build --image azure-vote-front:v1 --registry devopscatalogaks --file Dockerfile .

## DOCKER 
docker image ls 


## HELM ##
helm repo add stable https://charts.helm.sh/stable
helm search repo mongodb
helm show readme stable/mongodb
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency list go-demo-9
helm dependency update go-demo-9
helm -n production upgrade --install go-demo-9 go-demo-9 --wait --timeout 10m

##
curl -H "Host: go-demo-9.acme.com" "http://$INGRESS_HOST"


####################
# Create a Cluster #
####################

# This script assumes that you followed the instructions from the "Creating And Managing Google Kubernetes Engine (GKE) Clusters With Terraform" section" section.
# It assumes that you have:
# * The resource group *devops-catalog-aks*
# * The storage account *devopscatalog*
# * The storage container *devopscatalog*

# Make sure that you are inside the local copy of the devops-catalog-code repository

cd terraform-aks/minimal

terraform init

az aks get-versions --location eastus

# Replace `[...]` with a valid orchestratorVersion from the previous output
export K8S_VERSION=[...]

terraform refresh \
    --var k8s_version=$K8S_VERSION

terraform apply \
    --var k8s_version=$K8S_VERSION

export KUBECONFIG=$PWD/kubeconfig

az aks get-credentials \
    --name \
    $(terraform output --raw cluster_name) \
    --resource-group \
    $(terraform output --raw resource_group) \
    --file \
    $KUBECONFIG

kubectl get nodes

cd ../..

#############################
# Deploy Ingress Controller #
#############################

kubectl apply \
    --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/cloud/deploy.yaml

export INGRESS_HOST=$(kubectl \
    --namespace ingress-nginx \
    get svc ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $INGRESS_HOST

# Repeat the `export` command if the output is empty

#######################
# Destroy The Cluster #
#######################

cd terraform-aks/minimal

terraform destroy \
    --var k8s_version=$K8S_VERSION \
    --target azurerm_kubernetes_cluster.primary

cd ../..