# create an eks cluster, defined in the randmeth-fargate-cluster.yaml. This cluster definition file does not have a Fargate profile
eksctl create cluster -f randmeth-fargate-cluster.yaml
# set utility environment variables
export AWS_REGION=eu-west-1
export VPC_ID=$(aws eks describe-cluster --name randmeth-fargate-cluster --query "cluster.resourcesVpcConfig.vpcId" --output text)

# After successful creation of the cluster, view nodes in the cluster
kubectl get nodes -o wide
# create the Fargate profile, specifying cluster name, namespace, and match labels
eksctl create fargateprofile --cluster randmeth-fargate-cluster --name randmeth-campaigns --namespace randmeth --labels app=randmeth-campaigns
# view the profile
eksctl get fargateprofile --cluster randmeth-fargate-cluster -o yaml


# create namespace
kubectl apply -f randmeth-namespace.yaml
# apply the deployment and service

# set up IAM OIDC Provider to establish to allow Pods to authenticate with STS for identity in order to access other AWS services.
eksctl utils associate-iam-oidc-provider --cluster randmeth-fargate-cluster --region=$AWS_REGION --approve
# create IAM policy that will allow the ALB Ingress Controller to have the right AIM permissions to create and configure the ALB
aws iam create-policy   --policy-name ALBIngressControllerIAMPolicy   --policy-document file://aws-alb-ingress-iam-policy.json
# create env variable set to the policy arn
export FARGATE_POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`ALBIngressControllerIAMPolicy`].Arn' --output text)
# create a EKS service account and attach the policy to provide AWS permissions to containers in a pod that uses the service account
eksctl create iamserviceaccount  --name alb-ingress-controller --namespace randmeth --cluster randmeth-fargate-cluster --attach-policy-arn ${FARGATE_POLICY_ARN} --approve --override-existing-serviceaccounts
# get the status of the service account
kubectl get sa alb-ingress-controller -n randmeth -o yaml
# create the RBAC role for the alb-ingress-controller with the label app.kubernetes.io/name: alb-ingress-controller
kubectl apply -f rbac-role.yaml
#create Kubernetes service account for the alb-ingress-controller with the label app.kubernetes.io/name: alb-ingress-controller
kubectl apply -f service-account.yaml
#create role binding for the role and  the service account, with the label app.kubernetes.io/name: alb-ingress-controller
kubectl apply -f role-binding.yaml

kubectl apply -f campaigns-deployment.yaml
# view the status of the deployment creation
kubectl -n randmeth rollout status deployment randmeth-campaigns
# view pods on the cluster
kubectl get pods -o wide

#ssh ec2-user@ec2-63-35-186-51.eu-west-1.compute.amazonaws.com

# the following steps install the ALB Ingress Controller
helm --namespace randmeth install randmeth incubator/aws-alb-ingress-controller --set image.tag=${ALB_INGRESS_VERSION} --set awsRegion=${AWS_REGION} --set awsVpcID=${VPC_ID} --set rbac.create=false --set rbac.serviceAccount.name=alb-ingress-controller --set clusterName=randmeth-fargate-cluster
#view the status
kubectl -n randmeth rollout status deployment randmeth-aws-alb-ingress-controller
#view pods created for from the installation
kubectl --namespace=randmeth get pods -l "app.kubernetes.io/name=aws-alb-ingress-controller,app.kubernetes.io/instance=randmeth"

#view nodes and pods in the cluster. You see both cluster nodes and Farate pods posing as node
$kubectl get pods -n randmeth
$kubectl get node -n randmeth

#finally, apply the Ingress
kubectl apply -f ingress.yaml

# Extract the ingress url
export RANDMETH_URL=$(kubectl get ingress/randmeth-campaigns-ingress -n randmeth -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# take note of the url
echo "http://${RANDMETH_URL}"

# on postman or browser bar, type the following in order to see the list of campaigns from the service
curl http://${RANDMETH_URL}/api/v1/campaigns
