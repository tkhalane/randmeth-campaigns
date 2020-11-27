# =========================== CLEANING UP =======================================================

$kubectl delete -f ingress.yaml
$kubectl delete -f campaigns-deployment.yaml
$helm -n randmeth delete randmeth
$eksctl delete iamserviceaccount --name alb-ingress-controller --namespace randmeth --cluster randmeth-fargate-cluster
$kubectl delete -f service-account.yaml
$kubectl delete -f role-binding.yaml
$kubectl delete -f rbac-role.yaml
$eksctl delete fargateprofile --name randmeth-campaigns --cluster randmeth-fargate-cluster
$kubectl delete -f randmeth-namespace.yaml
$eksctl delete cluster --name  randmeth-fargate-cluster