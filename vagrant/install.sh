sudo apt-get update -y
sudo apt-get install -y curl
sudo apt-get install -y gnupg
sudo apt-get install -y lsb-release
sudo apt-get install -y net-tools
sudo apt-get install -y bind-utils
sudo apt-get install -y vim
sudo apt-get install -y openssh-server -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

# 테라폼 설치,  수동설치 한경우 확인용   #  terraform version
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get install -y terraform

# 도커 쿠버네티스 설치  
sudo swapoff -a  # SWAP 설정 OFF
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg # Docker 추가 Repository 구성(gpgkey keyring 설치, Repository 추가)
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker 패키지 설치
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker.service

# kubeadm, kubelet, kubectl 설치   Kubernetes 추가 Repository 구성(gpgkey keyring 설치, Repository 추가)
sudo curl -fssL https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# kubeadm, kubelet, kubectl 설치(버전 지정 및 고정)
sudo apt-get update -y
sudo apt-get install -y kubelet=1.23.5-00 kubeadm=1.23.5-00 kubectl=1.23.5-00
sudo apt-mark hold kubelet kubeadm kubectl