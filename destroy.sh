#!/bin/bash
#: Title   :MineOps EKS create script
#: Date :2022-10-07
#: Author : LSW <pro_4701@naver.com>
#: Version  : 1.0
#: Description : : Hi

echo "============================================ "
echo "destroy MineOps EKS create script "
date +%Y-%m-%d

DIR="$( cd "$( dirname "$0" )" && pwd -P )"




echo $DIR

while true; do
    read -p "로드밸런서 삭제되었음을 확인하셨습니까(y/n)??" yn
    echo " helm uninstall mine-release --namespace=mine-release " 
    case $yn in
        [Yy]* ) cd $DIR/env/terraform-eks/3-irsa ; terraform destroy -auto-approve ;cd $DIR/env/terraform-aws-ubuntu/network ; terraform destroy -auto-approve ; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# cd $DIR/env/terraform-eks/3-irsa ; terraform destroy -auto-approve

# cd $DIR/env/terraform-aws-ubuntu/network ; terraform destroy -auto-approve
