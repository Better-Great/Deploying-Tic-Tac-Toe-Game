
# Output the cluster endpoint and certificate
output "cluster_endpoint" {
  value = digitalocean_kubernetes_cluster.tic-tac-toe.endpoint
}

output "cluster_ca_certificate" {
  value = digitalocean_kubernetes_cluster.tic-tac-toe.kube_config[0].cluster_ca_certificate
  sensitive = true
}

# Output the kubeconfig file
resource "local_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.tic-tac-toe.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig.yaml"
}
