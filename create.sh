#!/bin/bash
#: Title   :MineOps EKS create script
#: Date :2022-10-07
#: Author : LSW <pro_4701@naver.com>
#: Version  : 1.0
#: Description : : Hi

echo "============================================"
echo " create MineOps EKS create script  "
echo " module.cluster.aws_eks_cluster.this: Still creating... [10m50s elapsed] "
echo " EKS 리소스 생성과정에서 10분 이상 시간 소모 "
date +%Y-%m-%d

# aws sts get-caller-identity 

DIR="$( cd "$( dirname "$0" )" && pwd -P )"
echo $DIR

cd $DIR/env/terraform-aws-ubuntu/network ; terraform init
terraform apply -auto-approve

cd $DIR/env/terraform-eks/3-irsa ; terraform init
terraform apply -auto-approve

aws eks update-kubeconfig --region ap-northeast-2 --name apne2-mineops --alias apne2-mineops
# EKS연결을 위해선 ~/.kube/config 파일 내 클러스터 연결 정보를 추가해야함

irsa_arn="$(terraform output irsa_arn)"
alb_arn="$(terraform output alb_arn)"

###########################################################################################  arn 교환 
cd $DIR/eks-irsa
echo $irsa_arn > arn_tmp
sed -i "s/role/role\\\/1" ./arn_tmp   # role -> role\/    이스케이프 전처리   

irsa_arn2="$(cat ./arn_tmp)" 
# rm -rf arn_tmp
sed -i "s/input/$irsa_arn2/1" ./rbac.yaml

kubectl create namespace mineopsname  # 에러경우 고려 필요
kubectl apply -k .


cd $DIR/eks-aws-load-balancer-controller/aws-load-balancer-controller
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.3/cert-manager.yaml

echo $alb_arn > arn_tmp
sed -i "s/role/role\\\/1" ./arn_tmp   # role -> role\/    이스케이프 전처리#   

alb_arn2="$(cat ./arn_tmp)" 
rm -rf arn_tmp
sed -i "s/input/$alb_arn2/1" ./rbac.yaml


###########################################################################################

cd $DIR
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

curl -L https://git.io/get_helm.sh | bash -s -- --version v3.8.2
###########################################################################################


helm repo add stable https://itzg.github.io/minecraft-server-charts/
helm fetch stable/minecraft --untar
/bin/cp values.yaml minecraft/values.yaml
kubectl create ns mine-release

helm install mine-release --namespace=mine-release ./minecraft -f ./minecraft/values.yaml

echo "============================================"
echo "kubectl get all -n mine-release 명령어에서 각 pod들이 running됬는지 확인 후(약 2분소요) "
echo "출력된 EXTERNAL-IP로 마인크래프트 클라이언트에서 접속"
echo "============================================"

# aa="$(terraform output vpc1)"
# echo $aa >vpc1
# #

# sed -i "s/\///g" ./vpc1   #  이거는 / 지우기
# sed -i "s/vpc\///g" ./vpc1   #  vpc 지우기,  (모든 vpc )
# sed -i "s/vpc\///1" ./vpc1   #  vpc 맨 처음 지우기,  (모든 vpc )  

# sed -i "s/\//\\/g" ./vpc1  #  이거는 암됨
# sed -i "s/\//\\\\//g" ./vpc1   #  이거는 /를 \/ 로 바꾸기   \ -> \\\   / -> \/    인데  \\\\ 4개인식이라 안된다

# sed -i "s/vpc/vpc\\\/1" ./vpc1   # 1회만 변경 


# cc="$(cat vpc1)"  # 

# sed -i "s/input/$cc/1" ./rbac.yaml   # 복붙으로 들어간 arn이 또 복사되므로 g가 아닌 1 옵션 



# sed -i ''
# echo $LSW2
#
# sed -i "s/arn/$LSW2/g" ./rbac.yaml
# sed -i "s/arn/ddd/g" ./rbac.yaml
# sed -i "s/ars::/arn/g" ./rbac.yaml
# sed -i "s/arn/arn:aws:ec2:ap-northeast-2:959714228357:vpc/vpc-00ea7001e778b6049/g" ./rbac.yaml
# sed -i "s/arn/arn:aws:ec2:ap-northeast-2:959714228357:vpc\/vpc-00ea7001e778b6049/g" ./rbac.yaml



