# Make sure the following are installed:
$aws --version
$eksctl version
$python3 --version
$pip3 --version
$kubectl version --cclient
$helm version

# set ALB version on
$echo 'export ALB_INGRESS_VERSION="v1.1.8"' >>  ~/.bash_profile .  ~/.bash_profile

# set AWS account ID by reading STS caller identy.
## 01/11/2020 this points to leseho, the IAM user
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=eu-west-1
#confirm configs
cat ~/.aws/config
cat ~/.aws/credentials
cat ~/.kube/config

# set default regiion
$aws configure set default.region ${AWS_REGION}
# confirm region
$aws configure get default.

# 01/11/2020 skipping to check if it is indeed necessary or not for fargate
# 01/11/2020 it all worked without doing this, still not sure if starting from scratch without it would work
  $aws ec2 import-key-pair --key-name "anyname" --public-key-material file://~/.ssh/id_rsa.pub

# 01/11/2020 eksworkshop	already enabled
# 01/11/2020 it all worked without doing this, still not sure if starting from scratch without it would work
$aws kms create-alias --alias-name alias/eksworkshop --target-key-id $(aws kms create-key --query KeyMetadata.Arn --output text)

# 11/01/2020 already set in bash_profile
export MASTER_ARN=$(aws kms describe-key --key-id alias/eksworkshop --query KeyMetadata.Arn --output text)
echo "export MASTER_ARN=${MASTER_ARN}" | tee -a ~/.bash_profile

# create ecr repo and push
#Retrieve an authentication token and authenticate your Docker client to your registry. Use the AWS CLI:
$ aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 314051162948.dkr.ecr.eu-west-1.amazonaws.com
# Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions here . You can skip this step if your image is already built:
$ docker build -t randmeth/campaigns:eks-demo .
# After the build completes, tag your image so you can push the image to this repository:
$ docker tag randmeth/campaigns:eks-demo 314051162948.dkr.ecr.eu-west-1.amazonaws.com/randmeth:eks-demo
# Run the following command to push this image to your newly created AWS repository:
$ docker push 314051162948.dkr.ecr.eu-west-1.amazonaws.com/randmeth:eks-demo




