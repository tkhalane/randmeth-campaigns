#
$sudo curl --silent --location -o /usr/local/bin/kubectl   https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl
$curl --silent --location -o /usr/local/bin/kubectl   https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl
$chmod +x /usr/local/bin/kubectl
$sudo chmod +x /usr/local/bin/kubectl

#install pythong3
$sudo apt install python3
python3 get-pip.py
# or is the below? confirm
$sudo apt install python3-pip
$sudo apt install awscli
# upgrade aws cli
sudo pip install --upgrade awscli && hash -r

# bash completion tools

$sudo apt-get install jq gettext bash-completion moreutils
for command in kubectl jq envsubst aws;
    do
      which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND";
    done

$kubectl completion bash >>  ~/.bash_completion . /etc/profile.d/bash_completion.sh
. ~/.bash_completion


# check for regin and account ID
# moved it here so that the other file is shorter
test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set
    $(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
        echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
        echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile

# generate ssh keys so that they can be imported to ec1
$cd ~
$ssh-keygen
$ls ~/.ssh/

# install eksctl and bash completion
$curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
$ls /tmp/
$sudo mv -v /tmp/eksctl /usr/local/bin
$eksctl completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion


# INSTALLING HELM VIA INSECURE HTTP CURL===
$curl -fsSL -k -o get_helm.sh https://raw.githubusercontent.com/$helm/$helm/master/scripts/get-$helm-3
$chmod 700 get_helm.sh
./get_helm.sh
$helm version
$helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
