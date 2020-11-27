#install EKSCTL
$curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
#Install HELM
$curl -fsSL -k -o get_helm.sh https://raw.githubusercontent.com/$helm/$helm/master/scripts/get-$helm-3
$chmod 700 get_helm.sh ./get_helm.sh
$helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator

# Make sure the following are installed:
$aws --version
$eksctl version
$python3 --version
$pip3 --version
$kubectl version --cclient
$helm version

# set the ALB Ingress version
$echo 'export ALB_INGRESS_VERSION="v1.1.8"' >>  ~/.bash_profile .  ~/.bash_profile

# set account Id
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=eu-west-1

# confirm configs
cat ~/.aws/config
cat ~/.aws/credentials
cat ~/.kube/config

# configure AWS CLI
$aws configure set default.region ${AWS_REGION}
$aws configure get default.
#Import SSH Keys
$aws ec2 import-key-pair --key-name "anyname" --public-key-material file://~/.ssh/id_rsa.pub
# push image after docker build
$ aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin xxxxxxx.dkr.ecr.eu-west-1.amazonaws.com
$ docker build -t randmeth/campaigns:eks-demo .
$ docker tag randmeth/campaigns:eks-demo xxxxxxx.dkr.ecr.eu-west-1.amazonaws.com/randmeth:eks-demo
$ docker push xxxxxxx.dkr.ecr.eu-west-1.amazonaws.com/randmeth:eks-demo




