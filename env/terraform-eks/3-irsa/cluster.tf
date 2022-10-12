module "cluster" {
  source  = "tedilabs/container/aws//modules/eks-cluster"  #  https://registry.terraform.io/modules/tedilabs/container/aws/latest/submodules/eks-cluster 레지스트리 참조
  version = "0.14.0"  # 0.13.0 버전에서 수정 

  name               = "apne2-mineops"
  kubernetes_version = "1.21"

  subnet_ids   = local.subnet_groups["public"].ids
  service_cidr = "172.20.0.0/16"

  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]  # 테스트용도로 퍼블릭 모두 허용 
  endpoint_private_access      = true
  endpoint_private_access_cidrs = [
    local.vpc.cidr_block,
  ]

  log_types = [ # 현재는 어떠한 로그도 허용 X , 과금문제 
    # "api", "audit", "authenticator", "controllerManager", "scheduler" 
  ]
  log_retention_in_days = 90
}
