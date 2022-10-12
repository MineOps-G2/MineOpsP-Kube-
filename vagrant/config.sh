echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

# swapoff -a to disable swapping
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

# alias  
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

# config DNS
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8 #Google DNS
EOF

# history , 사용자지정
echo 'HISTTIMEFORMAT="%Y/%m/%d %T"' >> ~/.bashrc
source ~/.bashrc

# ssh password Authentication no to yes
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
systemctl restart ssh
systemctl start systemd-timesyncd
timedatectl set-timezone UTC
systemctl restart sshd