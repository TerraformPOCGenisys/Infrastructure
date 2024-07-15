# For Deployer, a access for Gitlab Runner to patch Image version in deployment
# In "deployment-patch-access-role.yml" file, update Namespace name as you required
# First create role & role bindings by executing below command
kubectl apply -f deployment-patch-access-role-prod.yml
kubectl apply -f k8s-dev-access-role.yaml
# Now bind that EKS K8s User which name mentioned in above executed Role/RoleBiding file
# Here, update ARN of IAM User in "--arn" & update cluster name
# IMP update "--username" with User mentioned in above executed Role/RoleBiding file

eksctl create iamidentitymapping --cluster eks-stag-poc --arn arn:aws:iam::352730764496:user/github-eks-access-user --username k8s-access-user


# Verify the IAM User Binding with EKS K8s User
kubectl get cm -n kube-system aws-auth -o yaml