variable "cluster_name" {
    description = "The name of the EKS cluster resource."
    type        = string
}

variable "control_plane_subnets" {
    description = "List of subnet names for the control plane. Must be in at least two different availability zones."
    type        = set(string)
}