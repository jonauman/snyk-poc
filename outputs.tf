output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "Name of the created VPC network."
}

output "vpc_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "Self link of the created VPC network."
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "Name of the created subnet."
}

output "subnet_self_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "Self link of the created subnet."
}
