# create vpc
https://amazon-eks.s3.us-west-2.amazonaws.com/cloudformation/2020-06-10/amazon-eks-vpc-private-subnets.yaml
# create ecr repo


# === CREATING CLUSTER ==
$eksctl create cluster -f randmeth-fargate-cluster.yaml
# == COMPARE THIS FARGATE PROFILE WITH A DEPLOYMENT AND HOW IT MATCHES
# The Fargate profile allows an administrator to declare which pods run on Fargate. This declaration is done through the profile’s selectors.
# Each profile can have up to five selectors that contain a namespace and optional labels. You must define a namespace for every selector.
# added --labels app=randmeth-campaigns below remove if it doesn't work
$eksctl create fargateprofile --cluster randmeth-fargate-cluster --name randmeth-campaigns --namespace randmeth --labels app=randmeth-campaigns
$eksctl get fargateprofile --cluster randmeth-fargate-cluster -o yaml

# === APP K8S DEPLOYMENT ===

$kubectl apply -f randmeth-namespace.yaml
$kubectl apply -f campaigns-deployment.yaml
$kubectl -n randmeth rollout status deployment randmeth-campaigns
$kubectl get pods -o wide
$kubectl get nodes -o wide

$AWS_REGION

# ==== IAM PLUS RBAC FORf INGRESS TO CREATE AWS RESOURCES SUCH AS ALB, TARGET GROUPS, ETC
#=== AWS OPEN ID CONNECT PROVIDER  === VIA FILE

# OIDC federation access allows you to assume IAM roles via the Secure Token Service (STS),
# enabling authentication with an OIDC provider,
# receiving a JSON Web Token (JWT), which in turn can be used to assume an IAM role. Kubernetes,
# on the other hand, can issue so-called projected service account tokens, which happen to be valid OIDC JWTs for pods.
# The setup equips each pod with a cryptographically-signed token that can be verified by STS against the OIDC provider of your choice
# to establish the pod’s identity.
$eksctl utils associate-iam-oidc-provider --cluster randmeth-fargate-cluster --region=$AWS_REGION --approve
  # create IAM policy that
aws iam create-policy   --policy-name ALBIngressControllerIAMPolicy   --policy-document file://aws-alb-ingress-iam-policy.json
  # create env variable set to the policy arn
export FARGATE_POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`ALBIngressControllerIAMPolicy`].Arn' --output text)
  # create a Kubernetes service account and set up the IAM role that defines the access to the targeted service
  # With IAM roles for service accounts on Amazon EKS clusters, you can associate an IAM role with a Kubernetes service account.
  # This service account can then provide AWS permissions to the containers in any pod that uses that service account.
  # With this feature, you no longer need to provide extended permissions to the Amazon EKS node IAM role so that pods on that node can call AWS APIs.
$eksctl create iamserviceaccount  --name alb-ingress-controller --namespace randmeth --cluster randmeth-fargate-cluster --attach-policy-arn ${FARGATE_POLICY_ARN} --approve --override-existing-serviceaccounts
$kubectl get sa alb-ingress-controller -n randmeth -o yaml

# == RBAC ===
# 01/11/2020 first skipped, no load balancers were created after applying the ingress below
$kubectl apply -f rbac-role.yaml
$kubectl apply -f role-binding.yaml
$kubectl apply -f service-account.yaml

# INGRESS CONTROLLER via HELM==
#configure your pods by using the service account created in the previous step and assume the IAM role.
# Since the Ingress controller runs as Pod in one of your Nodes, all the Nodes should have permissions to describe, modify, etc.
# the Application Load Balancer
$helm version
export VPC_ID=$(aws eks describe-cluster --name randmeth-fargate-cluster --query "cluster.resourcesVpcConfig.vpcId" --output text)

$helm --namespace randmeth install randmeth incubator/aws-alb-ingress-controller --set image.tag=${ALB_INGRESS_VERSION} --set awsRegion=${AWS_REGION} --set awsVpcID=${VPC_ID} --set rbac.create=false --set rbac.serviceAccount.name=alb-ingress-controller --set clusterName=randmeth-fargate-cluster
$kubectl --namespace=randmeth get pods -l "app.kubernetes.io/name=aws-alb-ingress-controller,app.kubernetes.io/instance=randmeth"
$kubectl -n randmeth rollout status   deployment randmeth-aws-alb-ingress-controller
$kubectl get pods -n randmeth
$kubectl get node -n randmeth

# == INGRESS ===
$kubectl apply -f ingress.yaml
export RANDMETH_URL=$(kubectl get ingress/randmeth-campaigns-ingress -n randmeth -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "http://${RANDMETH_URL}"
