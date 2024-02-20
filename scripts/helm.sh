eksctl utils associate-iam-oidc-provider --cluster spring --approve

eksctl create iamserviceaccount --name ebs-csi-controller-sa --namespace kube-system --cluster spring --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy --approve --role-name AmazonEKS_EBS_CSI_DriverRole

SERVICE_ACCOUNT_ROLE_ARN=$(aws iam get-role --role-name AmazonEKS_EBS_CSI_DriverRole --output json | jq -r '.Role.Arn')

eksctl create addon --name aws-ebs-csi-driver --cluster spring --service-account-role-arn "$SERVICE_ACCOUNT_ROLE_ARN" --force

#eksctl create addon --name vpc-cni --cluster spring --service-account-role-arn "$SERVICE_ACCOUNT_ROLE_ARN" --force

#eksctl create addon --name kube-proxy --cluster spring --service-account-role-arn "$SERVICE_ACCOUNT_ROLE_ARN" --force

wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz
tar xvf helm-v3.9.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
sudo rm helm-v3.4.1-linux-amd64.tar.gz
sudo rm -rf linux-amd64
helm version

helm upgrade -i kubecost oci://public.ecr.aws/kubecost/cost-analyzer --version="1.104.4" --namespace kubecost --create-namespace -f https://raw.githubusercontent.com/kubecost/cost-analyzer-helm-chart/develop/cost-analyzer/values-eks-cost-monitoring.yaml --set prometheus.configmapReload.prometheus.enabled="false"
 
kubectl patch svc kubecost-cost-analyzer -n kubecost -p '{"spec": {"type": "LoadBalancer"}}'
